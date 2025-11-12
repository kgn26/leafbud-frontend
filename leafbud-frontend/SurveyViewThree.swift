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
    case small
    case medium
    case large
    
    var iconName: String {
        switch self {
        case .small:
            // SFSymbol for small size (e.g., a small leaf)
            return "leaf.fill"
        case .medium:
            // SFSymbol for medium size (e.g., a plant)
            return "tree.fill"
        case .large:
            // SFSymbol for large size (e.g., multiple trees/a large home)
            return "house.fill"
        }
    }
}

// ===================================================
// 2. MAIN VIEW
// ===================================================

struct SurveyViewThree: View {
    
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
                            title: "Small (Tabletop/Desk)",
                            icon: .small,
                            isSelected: selectedIcon == .small,
                            action: { selectedIcon = .small; print("Selected Small") }
                        )
                        
                        SurveyThreeOptionButton(
                            title: "Medium (Shelf/Stand)",
                            icon: .medium,
                            isSelected: selectedIcon == .medium,
                            action: { selectedIcon = .medium; print("Selected Medium") }
                        )
                        
                        SurveyThreeOptionButton(
                            title: "Large (Floor Plant)",
                            icon: .large,
                            isSelected: selectedIcon == .large,
                            action: { selectedIcon = .large; print("Selected Large") }
                        )
                    }
                    
                    Spacer() // Pushes remaining content up
                }
                .padding(.horizontal, 25)
                
                // Manual Back Button (Placeholder)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { print("Back button pressed (No navigation functionality yet)") }) {
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
            .navigationBarBackButtonHidden(true)
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
            .background(buttonGreen)
            .foregroundColor(darkGreen)
            .cornerRadius(15)
        }
    }
}

// MARK: - Preview
struct SurveyViewThree_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SurveyViewThree()
        }
    }
}
