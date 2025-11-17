//
//  SurveyViewTwo.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 11/12/25.
//

import SwiftUI

// ===================================================
// 1. ICON ENUM (Helper unique to this file)
// ===================================================

enum IconOption: CaseIterable {
    case bright
    case low
    
    var iconName: String {
        switch self {
        case .bright:
            return "sun.max.fill" // Full sun
        case .low:
            return "cloud.fill" // Shade/Low light
        }
    }
}

// ===================================================
// 2. MAIN VIEW
// ===================================================

struct SurveyViewTwo: View {
    @ObservedObject var surveyData: SurveyData
    
    // State to simulate selection
    @State private var selectedIcon: IconOption? = nil
    
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
                    
                    // Question Text (New question for page 2)
                    Text("How much sunlight does\nyour space receive?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(darkGreen)
                        .padding(.top, 20)
                    
                    // --- Survey Options ---
                    VStack(spacing: 15) { // Spacing between buttons
                        
                        OptionButton(
                            title: "Bright (South-facing)",
                            icon: .bright,
                            isSelected: selectedIcon == .bright,
                            action: {
                                selectedIcon = .bright;
                                surveyData.lightPref = "BRIGHT";
                                print("Selected Bright")
                            }
                        )
                        
                        OptionButton(
                            title: "Low (North-facing/Shady)",
                            icon: .low,
                            isSelected: selectedIcon == .low,
                            action: {
                                selectedIcon = .low;
                                surveyData.lightPref = "LOW";
                                print("Selected Low")
                            }
                        )
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: SurveyViewThree(surveyData: surveyData)) {
                        Text("Next")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(darkGreen)
                            .background(selectedIcon != nil ? darkGreen : buttonGreen)
                            .foregroundColor(.white)
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
// 3. REUSABLE BUTTON COMPONENT (Unique to this file)
// ===================================================

struct OptionButton: View {
    let title: String
    let icon: IconOption
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
