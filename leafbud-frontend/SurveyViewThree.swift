//
//  SurveyViewThree.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 11/12/25.
//

import SwiftUI

// ===================================================
// 1. ICON ENUM (Helper unique to this file)
// ===================================================

enum SurveyThreeIcon: CaseIterable {
    // UPDATED: Cases for plant size
    case xsmall
    case small
    case medium
    case large
    case xlarge
    
    var iconName: String {
        switch self {
        case .xsmall:
            // SFSymbol for extra small size (e.g., a tiny leaf)
            return "atom"
        case .small:
            // SFSymbol for small size (e.g., a small leaf)
            return "leaf.fill"
        case .medium:
            // SFSymbol for medium size (e.g., a plant)
            return "tree.fill"
        case .large:
            // SFSymbol for large size (e.g., multiple trees/a large home)
            return "house.fill"
        case .xlarge:
            // SFSymbol for extra large size (e.g., a large tree)
            return "globe"
        }
    }
}

// ===================================================
// 2. MAIN VIEW
// ===================================================

struct SurveyViewThree: View {
    @ObservedObject var surveyData: SurveyData
    
    // State to simulate selection
    @State private var selectedIcon: SurveyThreeIcon? = nil
    
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
                    
                    // Question Text (UPDATED)
                    Text("What size plant\nare you looking for?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(darkGreen)
                        .padding(.top, 20)
                    
                    // --- Survey Options ---
                    VStack(spacing: 15) { // Spacing between buttons
                        
                        SurveyThreeOptionButton(
                            title: "Extra Small (Tiny)",
                            icon: .xsmall,
                            isSelected: selectedIcon == .xsmall,
                            action: {
                                selectedIcon = .xsmall;
                                surveyData.size = "XS";
                                print("Selected ExtraSmall")
                            }
                        )
                        
                        SurveyThreeOptionButton(
                            title: "Small (Tabletop/Desk)",
                            icon: .small,
                            isSelected: selectedIcon == .small,
                            action: {
                                selectedIcon = .small;
                                surveyData.size = "S";
                                print("Selected Small")
                            }
                        )
                        
                        SurveyThreeOptionButton(
                            title: "Medium (Shelf/Stand)",
                            icon: .medium,
                            isSelected: selectedIcon == .medium,
                            action: {
                                selectedIcon = .medium;
                                surveyData.size = "M";
                                print("Selected Medium")
                            }
                        )
                        
                        SurveyThreeOptionButton(
                            title: "Large (Floor Plant)",
                            icon: .large,
                            isSelected: selectedIcon == .large,
                            action: { selectedIcon = .large;
                                surveyData.size = "L";
                                print("Selected Large") }
                        )
                        
                        SurveyThreeOptionButton(
                            title: "Extra Large (Giantz)",
                            icon: .xlarge,
                            isSelected: selectedIcon == .xlarge,
                            action: {
                                selectedIcon = .xlarge;
                                surveyData.size = "XL";
                                print("Selected Extra Large")
                            }
                        )
                    }
                    
                    Spacer() // Pushes remaining content up
                    
                    NavigationLink(destination: SurveyViewFour(surveyData: surveyData)) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedIcon != nil ? darkGreen : buttonGreen)
                            .cornerRadius(15)
                    }
                    .disabled(selectedIcon == nil)
                }
                .padding(.horizontal, 25)
            }
        }
    }
}

// ===================================================
// 3. REUSABLE BUTTON COMPONENT (Unchanged)
// ===================================================

struct SurveyThreeOptionButton: View {
    // ICON TYPE MUST MATCH THE ENUM NAME
    let title: String
    let icon: SurveyThreeIcon
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
