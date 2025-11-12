//
//  LandingView.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 11/7/25.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        // Use a ZStack for the background color and then a VStack for content
        ZStack {
            // Background color - replace .green with your specific hex color if needed
            Color(red: 236/255, green: 240/255, blue: 234/255) // Light green background from your design
                .ignoresSafeArea() // Extends the color to the safe areas

            VStack(spacing: 20) { // Add spacing between elements
                Spacer()
                    .frame(maxHeight: 10) // This reduces the space to a maximum of 100 points.
                
                // Welcome to Leafbud! Text
                Text("Welcome to Leafbud!")
                    .font(.system(size: 55)) // Or a custom font, e.g., .custom("YourFontName", size: 34)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 53/255, green: 79/255, blue: 50/255)) // Dark green text
                
                // Leafbud Logo Image
                // Make sure you have an image named "leafbudLogo" in your Assets.xcassets
                Image("leafbudLogo") // Assuming you named your pixel plant image "leafbudLogo"
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120) // Adjust size as needed

                // Description Text
                Text("Your Personal Plant Buddy")
                    .font(.system(size: 22)) // Or a custom font
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 53/255, green: 79/255, blue: 50/255))
                    .padding(.horizontal) // Add horizontal padding for better readability
                
                // 4. Description Text (Part 2 - Left Aligned)
                VStack(alignment: .leading, spacing: 20) { // spacing: 10 creates the space
                    
                    // This is your first text block
                    Text("Let's find your perfect plant match! We'll start off asking you a few questions to learn more about your living space and lifestyle.")
                        .font(.system(size: 17))
                        .multilineTextAlignment(.leading)
                    
                    // This is the new text you wanted to add
                    Text("Get ready for a new plant buddy!")
                        .font(.system(size:17))
                }
                .foregroundColor(Color(red: 53/255, green: 79/255, blue: 50/255))
                .frame(maxWidth: .infinity, alignment: .leading) // Forces the whole group left
                .padding(.horizontal, 60) //make balanced
                
                Spacer()
                    .frame(maxHeight: 0) // This reduces the space to a maximum of 100 points.
                
                // Start Your Journey Button
                NavigationLink(destination: EmptyView()) { // This will navigate to SurveyView
                    Text("Start Your Journey")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 15)    // Controls height
                        .padding(.horizontal, 55) // <-- ADJUSTED: Increase this number (e.g., 40, 50, 60) to make the button wider.
                        .background(Color(red: 99/255, green: 139/255, blue: 104/255)) // Darker green button
                        .cornerRadius(20)
                }
                // The NavigationLink itself is centered by the parent VStack

                // I already have a plant link
                Button(action: {
                    // Action for "I already have a plant" - maybe navigate to a different part of the app
                    print("I already have a plant tapped!")
                }) {
                    Text("I already have a plant")
                        .font(.system(size:17))
                        .foregroundColor(Color(red: 99/255, green: 139/255, blue: 104/255))
                }
                .padding(.bottom, 50) // Padding from the bottom edge
            }
        }
    }
}

#Preview {
    LandingView()
}
