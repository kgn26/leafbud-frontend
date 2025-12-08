//
//  CompletionView.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 11/12/25.
//

import SwiftUI

struct CompletionView: View {
    
    // Define the custom colors used in the design
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)
    let buttonGreen = Color(red: 99/255, green: 139/255, blue: 104/255) // The darker, action button green
    let lightBgColor = Color(red: 236/255, green: 240/255, blue: 234/255)

    var body: some View {
        ZStack {
            lightBgColor.ignoresSafeArea()
            
            VStack(spacing: 30) {
                
//                Spacer() // Pushes content down from the top
//                    .frame(maxHeight: 0) // This reduces the space to a maximum of 100 points.
                
                // 1. Title Text
                Text("Cast Iron is happy to be your plant buddy!")
                    .font(.system(size:40))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(darkGreen)
                
                // 2. Plant Image (UPDATED to use "leafbudLogo")
                Image("castIron") // <--- CHANGED THIS LINE
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                // 3. Prompt Text
                Text("Are you ready to embark on your plant journey?")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(darkGreen)
                    .padding(.top, 20)

                // Spacer() // Pushes content up from the bottom button

                // 4. "Let's go!" Button
                Button(action: {
                    print("Completion flow finished! Entering main app.")
                }) {
                    Text("Let's go!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 50)
                        .background(buttonGreen)
                        .cornerRadius(25) // Highly rounded corners
                }
                .padding(.bottom, 5) // Padding from the bottom edge
            }
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - Preview
struct CompletionView_Previews: PreviewProvider {
    static var previews: some View {
        CompletionView()
    }
}
