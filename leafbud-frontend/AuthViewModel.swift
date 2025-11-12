//
//  AuthViewModel.swift
//  leafbud-frontend
//
//  Created by Khanh Nguyen on 11/5/25.
//

import SwiftUI
import Combine
import Supabase
import CryptoKit
import AuthenticationServices
import GoogleSignInSwift

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    
    private init() {
        Task {
            await MainActor.run { self.isLoading = true }
            await restoreSession()
            await MainActor.run { self.isLoading = false }
        }
    }
    
    @Published var isAuthenticated: Bool = false
    @Published var isLoading = false
    @Published var checkingSession = true
    @Published var showSignUp = false
    @Published var errMsg: String? = nil
    @Published var signedUp: Bool = false
    @Published var user: Auth.User?
    @Published var session: Session?
    
    private let client = SupabaseManager.shared.client
    
    // MARK: Sign In
    func signIn(email: String, password: String) async {
        await MainActor.run {
            self.isLoading = true
            self.errMsg = nil
        }
        
        defer {
            Task { await MainActor.run { self.isLoading = false } }
        }
        
        do {
            let session = try await client.auth.signIn(email: email, password: password)
            await MainActor.run {
                self.session = session
                self.user = session.user
                self.isAuthenticated = true
            }
            
            // Save to Keychain
            KeychainManager.save(session.accessToken, for: "accessToken")
            KeychainManager.save(session.refreshToken, for: "refreshToken")
            print("✅ Signed in and saved tokens")
        } catch {
            await MainActor.run { self.errMsg = error.localizedDescription }
        }
    }
    
    // MARK: - Restore Session
    func restoreSession() async {
        defer {
            Task { await MainActor.run { self.checkingSession = false } }
        }
        
        guard let access = KeychainManager.load("accessToken"),
              let refresh = KeychainManager.load("refreshToken") else {
            print("⚠️ No saved session in Keychain")
            return
        }
        
        do {
            let session = try await client.auth.setSession(
                accessToken: access,
                refreshToken: refresh
            )
            await MainActor.run {
                self.session = session
                self.user = session.user
                self.isAuthenticated = true
            }
            print("✅ Restored session from Keychain")
        } catch {
            print("⚠️ Failed to restore session: \(error.localizedDescription)")
        }
    }

    // MARK: Sign Up
    func signUp(fname: String, lname: String, username: String, email: String, password: String) async {
        await MainActor.run {
            self.isLoading = true
            self.errMsg = nil
        }
        do {
            try await client.auth.signUp(
                email: email,
                password: password,
                data: [
                    "first_name": .string(fname),
                    "last_name": .string(lname),
                    "username": .string(username)
                ]
            )
        } catch {
            await MainActor.run {
                self.errMsg = error.localizedDescription
            }
        }
        await MainActor.run {
            self.isLoading = false
        }
    }
    
    // MARK: Sign Out
    func signOut() async {
        do {
            try await client.auth.signOut()
            KeychainManager.delete("accessToken")
            KeychainManager.delete("refreshToken")
            await MainActor.run {
                self.session = nil
                self.user = nil
                self.isAuthenticated = false
            }
            print("👋 Signed out and cleared tokens")
        } catch {
            await MainActor.run { self.errMsg = error.localizedDescription }
        }
    }
}


final class SupabaseManager {
    static let shared = SupabaseManager()
    let client: SupabaseClient
    
    private init() {
        guard let env = Bundle.main.infoDictionary else {
            fatalError("Supabase Manager: Config dictionary not found")
        }
        guard let urlString = env["SUPABASE_URL"] as? String else {
            fatalError("Supabase Manager: Supabase URL not found")
        }
        guard let key = env["SUPABASE_PUB_KEY"] as? String else {
            fatalError("Supabase Manager: Supabase publishable key not found")
        }
        guard let url = URL(string: urlString) else {
            fatalError("Supabase Manager: Invalid URL")
        }
        
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: key
        )
    }
}


struct GoogleSignInButtonView: View {
    var body: some View {
        Button {
            Task { await handleGoogleSignIn() }
        } label: {
            HStack(spacing: 0) {
                Image("google-logo")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("Sign in with Google")
                    .font(.system(size: 20, weight: .medium, design: .none))
            }
            .frame(maxWidth: .infinity, minHeight: 50)
            .foregroundColor(.black)
            .background(Color.white)
            .cornerRadius(10)
        }
    }
    
    func handleGoogleSignIn() async {
        Task {
            print("Signing in with Google...")
        }
    }
}

struct AppleSignInButtonView: View {
    private let client = SupabaseManager.shared.client
    
    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            Task {
                do {
                    guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
                    else {
                        return
                    }
                    guard let idToken = credential.identityToken
                        .flatMap({ String(data: $0, encoding: .utf8) })
                    else {
                        return
                    }
                    try await client.auth.signInWithIdToken(
                        credentials: .init(
                            provider: .apple,
                            idToken: idToken
                        )
                    )
                    // Apple only provides the user's full name on the first sign-in
                    // Save it to user metadata if available
                    if let fullName = credential.fullName {
                        var nameParts: [String] = []
                        if let givenName = fullName.givenName {
                            nameParts.append(givenName)
                        }
                        if let middleName = fullName.middleName {
                            nameParts.append(middleName)
                        }
                        if let familyName = fullName.familyName {
                            nameParts.append(familyName)
                        }
                        let fullNameString = nameParts.joined(separator: " ")
                        try await client.auth.update(
                            user: UserAttributes(
                                data: [
                                    "full_name": .string(fullNameString),
                                    "given_name": .string(fullName.givenName ?? ""),
                                    "family_name": .string(fullName.familyName ?? "")
                                ]
                            )
                        )
                    }
                    // User successfully signed in
                    print("Sign in with Apple successful!")
                } catch {
                    // Handle sign-in errors
                    print("Sign in with Apple failed: \(error.localizedDescription)")
                    // Show error alert to user
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50.0)
        .cornerRadius(10)
    }
}
