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
                            action: { selectedIcon = .bright; print("Selected Bright") }
                        )
                        
                        OptionButton(
                            title: "Low (North-facing/Shady)",
                            icon: .low,
                            isSelected: selectedIcon == .low,
                            action: { selectedIcon = .low; print("Selected Low") }
                        )
                    }
                    
                    Spacer() // Pushes remaining content up
                }
                .padding(.horizontal, 25)
                
                // Manual Back Button (Placeholder)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { print("Navigate back to SurveyView") }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(darkGreen)
                                .padding(8)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                    }
                }
            }
            // Hides the default back arrow, using the manual one above
            .navigationBarBackButtonHidden(true)
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
            .background(buttonGreen)
            .foregroundColor(darkGreen)
            .cornerRadius(15)
        }
    }
}

// MARK: - Preview
struct SurveyViewTwo_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SurveyViewTwo()
        }
    }
}
