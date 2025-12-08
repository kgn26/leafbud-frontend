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
    @ObservedObject var surveyData: SurveyData
    
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
                            action: {
                                selectedIcon = .leaveAlone;
                                surveyData.difficulty = "EASY"
                                print("Selected Leave Alone")
                            }
                        )
                        
                        SurveyOneOptionButton(
                            title: "I like the attention",
                            icon: .attention,
                            isSelected: selectedIcon == .attention,
                            action: {
                                selectedIcon = .attention;
                                surveyData.difficulty = "MEDIUM"
                                print("Selected Attention")
                            }
                        )
                        
                        SurveyOneOptionButton(
                            title: "Don't leave me",
                            icon: .dontLeave,
                            isSelected: selectedIcon == .dontLeave,
                            action: {
                                selectedIcon = .dontLeave;
                                surveyData.difficulty = "HARD"
                                print("Selected Don't Leave")
                            }
                        )
                    }
                    
                    Spacer() // Pushes remaining content up
                    
                    // --- Next Button ---
                    NavigationLink(
                        destination: SurveyViewTwo(surveyData: surveyData),
                        label: {
                            Text("Next")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 15)
                                .foregroundColor(.white)
                                .background(selectedIcon != nil ? darkGreen : buttonGreen)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    )
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
