//
//  SurveyViewFour.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 11/12/25.
//

import SwiftUI

// ===================================================
// 1. ICON ENUM (Helper unique to this file)
// ===================================================

enum SurveyFourIcon: CaseIterable {
    case yesSafe
    case noNeed
    
    var iconName: String {
        switch self {
        case .yesSafe:
            // Shield for safety
            return "hand.raised.square.fill"
        case .noNeed:
            // Paw/Child outline for non-safe option
            return "pawprint"
        }
    }
}

// ===================================================
// 2. MAIN VIEW
// ===================================================

struct SurveyViewFour: View {
    @ObservedObject var surveyData: SurveyData
    
    // State to simulate selection
    @State private var selectedIcon: SurveyFourIcon? = nil
    
    // Define the custom colors used in the design
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)
    let buttonGreen = Color(red: 167/255, green: 198/255, blue: 168/255)
    let lightBgColor = Color(red: 236/255, green: 240/255, blue: 234/255)

    var body: some View {
        NavigationStack {
            ZStack {
                lightBgColor.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 50) { // Spacing between Q and A
                    
                    // Spacer to push content down
                    Spacer()
                        .frame(maxHeight: 50)
                    
                    // Question Text
                    Text("Do you need pet or\nchild-friendly plants?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(darkGreen)
                        .padding(.top, 20)
                    
                    // --- Survey Options ---
                    VStack(spacing: 15) { // Spacing between buttons
                        
                        SurveyFourOptionButton(
                            title: "Yes, 100% Non-Toxic",
                            icon: .yesSafe,
                            isSelected: selectedIcon == .yesSafe,
                            action: {
                                selectedIcon = .yesSafe;
                                surveyData.hasPets = true;
                                print("Selected Safe")
                            }
                        )
                        
                        SurveyFourOptionButton(
                            title: "No, safety is not a concern",
                            icon: .noNeed,
                            isSelected: selectedIcon == .noNeed,
                            action: {
                                selectedIcon = .noNeed;
                                surveyData.hasPets = false;
                                print("Selected Not Concerned")
                            }
                        )
                        
                        // Add a placeholder to balance the layout, matching the other three-option screens
                        Spacer()
                        
                        NavigationLink(destination: RecommendationView(surveyData: surveyData)) {
                            Text("See My Recommendations")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedIcon != nil ? darkGreen : buttonGreen)
                                .cornerRadius(15)
                        }
                        .disabled(selectedIcon == nil)
                    }
                    
                    Spacer() // Pushes remaining content up
                }
                .padding(.horizontal, 25)
            }
        }
    }
}

// ===================================================
// 3. REUSABLE BUTTON COMPONENT (Unique to this file)
// ===================================================

struct SurveyFourOptionButton: View {
    let title: String
    let icon: SurveyFourIcon
    let isSelected: Bool
    let action: () -> Void
    
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)
    let buttonGreen = Color(red: 167/255, green: 198/255, blue: 168/255)
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: icon.iconName)
                    .font(.title2)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .background(isSelected ? darkGreen : buttonGreen)   // 🟢 Highlight selected
            .foregroundColor(isSelected ? .white : darkGreen)   // 🟢 Adjust text/icon color
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(darkGreen, lineWidth: isSelected ? 3 : 0)
            )
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
    }
}
