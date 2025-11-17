//
//  ContentView.swift
//  leafbud-frontend
//
//  Created by Khanh Nguyen on 11/5/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    @EnvironmentObject private var auth: AuthViewModel
    
    var body: some View {
        if auth.checkingSession {
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundGrn.ignoresSafeArea())
        } else if !auth.isAuthenticated {
            AuthView()
        } else if auth.user == nil {
            ZStack {
                Color.bgGreen.ignoresSafeArea(edges: .all)
                VStack {
                    Text("You have to log in to continue")
                    NavigationLink(destination: AuthView()) {
                        Text("Go to log in")
                            .font(.headline)
                            .padding()
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
            }
        } else if plantInst.userPlant == nil {
            SurveyView()
        } else {
            MainView()
                .onAppear {
                    // Request notification permission once the main app view loads
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options: [.sound, .alert, .badge]) { granted, error in
                        if let error = error {
                            print("⚠️ Notification permission error: \(error.localizedDescription)")
                            return
                        }
                        if granted {
                            print("✅ Notification permission granted")
                        } else {
                            print("🚫 Notification permission denied")
                        }
                    }
                    
                    Task { await plantInst.fetchData() }
                    
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel.shared)
        .environmentObject(PlantInstViewModel.shared)
}
