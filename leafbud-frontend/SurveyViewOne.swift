//
//  SurveyViewOne.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 11/12/25.
//

import SwiftUI

// ===================================================
// 1. ICON ENUM (Helper unique to this file)
// ===================================================

enum SurveyOneIcon: CaseIterable {
    case leaveAlone
    case attention
    case dontLeave
    
    var iconName: String {
        switch self {
        case .leaveAlone:
            // Slash circle for 'Leave me alone'
            return "slash.circle"
        case .attention:
            // Checkmark for 'I like the attention'
            return "checkmark"
        case .dontLeave:
            // Exclamation triangle for 'Don't leave me'
            return "exclamationmark.triangle.fill"
        }
    }
}

// ===================================================
// 2. MAIN VIEW
// ===================================================

struct SurveyViewOne: View {
    
    // State to simulate selection
    @State private var selectedIcon: SurveyOneIcon? = nil
    
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
                    Text("How clingy is your\nplant buddy?")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(darkGreen)
                        .padding(.top, 20)
                    
                    // --- Survey Options ---
                    VStack(spacing: 15) { // Spacing between buttons
                        
                        SurveyOneOptionButton(
                            title: "Leave me alone",
                            icon: .leaveAlone,
                            isSelected: selectedIcon == .leaveAlone,
                            action: { selectedIcon = .leaveAlone; print("Selected Leave Alone") }
                        )
                        
                        SurveyOneOptionButton(
                            title: "I like the attention",
                            icon: .attention,
                            isSelected: selectedIcon == .attention,
                            action: { selectedIcon = .attention; print("Selected Attention") }
                        )
                        
                        SurveyOneOptionButton(
                            title: "Don't leave me",
                            icon: .dontLeave,
                            isSelected: selectedIcon == .dontLeave,
                            action: { selectedIcon = .dontLeave; print("Selected Don't Leave") }
                        )
                    }
                    
                    Spacer() // Pushes remaining content up
                }
                .padding(.horizontal, 25)
                
                // Manual Back Button (Placeholder, non-functional yet)
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
// 3. REUSABLE BUTTON COMPONENT (Unique to this file)
// ===================================================

struct SurveyOneOptionButton: View {
    let title: String
    let icon: SurveyOneIcon
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
struct SurveyViewOne_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SurveyViewOne()
        }
    }
}
