//
//  AuthView.swift
//  leafbud-frontend
//
//  Created by Khanh Nguyen on 11/5/25.
//

import SwiftUI

struct AuthView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                Image("appAvatar")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .padding(.bottom, 10)
                
                Text("Leafbud")
                    .font(.system(size: 36))
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .padding(.bottom, 30)
                    .foregroundStyle(Color(.textGreen))
                
                NavigationLink(destination: SignInView()) {
                    Text("Continue with Email")
                        .fontDesign(.serif)
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.textGreen)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Divider()
                
                GoogleSignInButtonView()
                
                AppleSignInButtonView()
                
                NavigationLink(destination: SignUpView()) {
                    Text("Don’t have an account?")
                        .foregroundStyle(Color(.textGreen))
                        .fontDesign(.serif)
                    Text("Sign Up")
                        .font(.headline)
                        .fontDesign(.serif)
                        .foregroundStyle(Color(.textGreen))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.bgGreen).ignoresSafeArea())
        }
    }
}


struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginFailed = false
    @EnvironmentObject var authvm: AuthViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Welcome Back, Sprout!")
                .font(.system(size: 36))
                .fontWeight(.bold)
                .fontDesign(.serif)
                .padding(.bottom, 30)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(.textGreen))
            
            //            if let errMsg = authvm.errMsg {
            //                Text(errMsg)
            //                    .font(.callout)
            //                    .foregroundStyle(Color(.systemRed))
            //                    .padding(.top, 20)
            //            }
            
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .fontDesign(.serif)
                .padding()
                .background(Color(.bgGreenSecondary))
                .cornerRadius(8)
            
            SecureField("Password", text: $password)
                .padding()
                .fontDesign(.serif)
                .background(Color(.bgGreenSecondary))
                .cornerRadius(8)
            
            Button {
                
            } label: {
                Text("Forgot Password?")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .fontDesign(.serif)
                    .foregroundStyle(Color(.textGreen))
            }
            
            Button(action: {
                print("Signing in...")
                Task {
                    let _ = await authvm.signIn(email: email, password: password)
                    if let err = authvm.errMsg {
                        loginFailed = true
                        print(err)
                    }
                }
            }) {
                if authvm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.textGreen)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } else {
                    Text("Sign In")
                        .font(.headline)
                        .fontDesign(.serif)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.textGreen)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(email.isEmpty || password.isEmpty)
                }
            }
            
            NavigationLink(destination: SignUpView()) {
                Text("Don’t have an account?")
                    .foregroundStyle(Color(.textGreen))
                    .fontDesign(.serif)
                Text("Sign Up")
                    .font(.headline)
                    .fontDesign(.serif)
                    .foregroundStyle(Color(.textGreen))
            }
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.bgGreen).ignoresSafeArea())
        .alert(
            "Login Failed",
            isPresented: $loginFailed
        ) {
            Button("OK") {
                // Handle the acknowledgement.
            }
        } message: {
            Text("Please check your credentials and try again.")
        }
    }
}


struct SignUpView: View {
    @State private var fname = ""
    @State private var lname = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var termsRead = false
    @State private var signUpFailed = false
    @EnvironmentObject var authvm: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Join the Leafbud Garden")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .fontDesign(.serif)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(.textGreen))
            
            HStack(spacing: 15) {
                TextField("First Name", text: $fname)
                    .autocapitalization(.words)
                    .fontDesign(.serif)
                    .padding()
                    .background(Color(.bgGreenSecondary))
                    .cornerRadius(8)
                
                TextField("Last Name", text: $lname)
                    .autocapitalization(.words)
                    .fontDesign(.serif)
                    .padding()
                    .background(Color(.bgGreenSecondary))
                    .cornerRadius(8)
            }
            
            TextField("Username", text: $username)
                .autocapitalization(.none)
                .fontDesign(.serif)
                .padding()
                .background(Color(.bgGreenSecondary))
                .cornerRadius(8)
            
            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .fontDesign(.serif)
                .padding()
                .background(Color(.bgGreenSecondary))
                .cornerRadius(8)
            
            SecureField("Password", text: $password)
                .fontDesign(.serif)
                .padding()
                .background(Color(.bgGreenSecondary))
                .cornerRadius(8)
            
            Button(action: {
                print("Signing up...")
                Task {
                    await authvm.signUp(fname: fname, lname: lname, username: username, email: email, password: password)
                    if authvm.errMsg == nil {
                        dismiss()
                    } else {
                        signUpFailed = true
                    }
                }
            }) {
                if authvm.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.textGreen)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                } else {
                    Text("Sign Up")
                        .font(.headline)
                        .fontDesign(.serif)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.textGreen)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .disabled(email.isEmpty || password.isEmpty)
                }
            }
            
            Toggle(isOn: $termsRead) {
                Text("I agree to the")
                    .foregroundStyle(Color.textGreen)
                Text("Terms & Privacy Policy")
                    .foregroundStyle(Color.textGreen)
                    .underline(true)
                
            }
            .toggleStyle(.button)
            
            Divider()
            
            GoogleSignInButtonView()
            AppleSignInButtonView()
            
            NavigationLink(destination: SignInView()) {
                Text("Have an account?")
                    .foregroundStyle(Color(.textGreen))
                    .fontDesign(.serif)
                Text("Log In")
                    .font(.headline)
                    .fontDesign(.serif)
                    .foregroundStyle(Color(.textGreen))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.bgGreen).ignoresSafeArea())
        .sheet(isPresented: $authvm.signedUp) {
            Text("Account created. Please log in to proceed!")
        }
        .alert(
            "Sign Up Failed",
            isPresented: $signUpFailed
        ) {
            Button("OK") {
                // Handle the acknowledgement.
            }
        } message: {
            Text("Please check your credentials and try again.")
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel.shared)
}
