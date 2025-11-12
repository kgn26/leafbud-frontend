//
//  RecommendationView.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 11/12/25.
//

import SwiftUI

// ===================================================
// 1. DATA MODEL (Placeholder for the recommended plants)
// ===================================================

struct Plant {
    let name: String
    let imageAsset: String
    let careTime: String // e.g., "Moderate"
    let light: String    // e.g., "Medium"
    let size: String     // e.g., "Large"
    let toxic: String    // e.g., "Toxic" or "Non-Toxic"
    let tags: [String]
}

// ===================================================
// 2. MAIN VIEW
// ===================================================

struct RecommendationView: View {
    
    // Placeholder data matching your screenshot
    let recommendations = [
        // Note: Using the new image assets you referenced: arecaPalm, castIron, bostonFern
        Plant(name: "Areca Palm", imageAsset: "arecaPalm", careTime: "Moderate", light: "Medium", size: "Large", toxic: "Toxic", tags: ["Tag", "Sample Tag"]),
        Plant(name: "Cast Iron", imageAsset: "castIron", careTime: "Moderate", light: "Medium", size: "Large", toxic: "Toxic", tags: ["Tag", "Sample Tag"]),
        Plant(name: "Boston Fern", imageAsset: "bostonFern", careTime: "Moderate", light: "Medium", size: "Large", toxic: "Toxic", tags: ["Tag", "Sample Tag"])
    ]
    
    // Define the custom colors used in the design
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)
    let cardGreen = Color(red: 216/255, green: 227/255, blue: 216/255) // Light background green for the card
    let lightBgColor = Color(red: 236/255, green: 240/255, blue: 234/255)

    var body: some View {
        NavigationStack {
            ZStack {
                lightBgColor.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Spacer to align content lower on the screen
                    Spacer()
                        .frame(maxHeight: 50)
                    
                    // Title Text
                    Text("We recommend\nthese plants:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(darkGreen)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 20)
                    
                    // ScrollView to contain the list of cards
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(recommendations, id: \.name) { plant in
                                // Each card is wrapped in a button to simulate selection
                                Button(action: {
                                    print("Selected \(plant.name). Navigating to completion screen.")
                                }) {
                                    PlantRecommendationCard(plant: plant)
                                }
                                .buttonStyle(PlainButtonStyle()) // Remove default button highlight style
                            }
                        }
                        .padding(.horizontal, 25) // Pad the ScrollView content
                        .padding(.bottom, 50) // Ensure space at the bottom of the list
                    }
                }
                
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
// 3. REUSABLE PLANT CARD COMPONENT (UPDATED FOR 2x2 LAYOUT)
// ===================================================

struct PlantRecommendationCard: View {
    let plant: Plant
    
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)
    let cardGreen = Color(red: 216/255, green: 227/255, blue: 216/255)
    let tagGreen = Color(red: 173/255, green: 205/255, blue: 173/255)

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            // Left side: Name, Details, and Tags
            VStack(alignment: .leading, spacing: 5) {
                
                // Plant Name
                Text(plant.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(darkGreen)
                    .padding(.bottom, 8)
                
                // ----------------------------------------------------
                // NEW: 2x2 Detail Grid (HStack containing two VStacks)
                // ----------------------------------------------------
                HStack(alignment: .top, spacing: 15) { // Reduced spacing for tightness
                    
                    // Column 1: Care Time and Size
                    VStack(alignment: .leading, spacing: 4) {
                        CareDetailRow(icon: "clock.fill", label: plant.careTime)
                        CareDetailRow(icon: "ruler.fill", label: plant.size)
                    }
                    
                    // Column 2: Light and Toxicity
                    VStack(alignment: .leading, spacing: 4) {
                        CareDetailRow(icon: "sun.max.fill", label: plant.light)
                        CareDetailRow(icon: "triangle.fill", label: plant.toxic)
                    }
                }
                .padding(.bottom, 15) // Space between details and tags
                
                // Tags
                HStack(spacing: 8) {
                    ForEach(plant.tags.prefix(2), id: \.self) { tag in
                        TagView(tag: tag, color: tagGreen)
                    }
                    TagView(tag: "+5 more", color: tagGreen)
                }
            }
            
            Spacer()
            
            // Right side: Plant Image
            Image(plant.imageAsset)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
        }
        .padding(15)
        .background(cardGreen)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}

// Helper view for a single detail row (Icon + Text)
struct CareDetailRow: View {
    let icon: String
    let label: String
    
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)

    var body: some View {
        HStack(spacing: 3) { // Reduced spacing for tight alignment
            Image(systemName: icon)
                .font(.caption) // Small font size for the icon
                .foregroundColor(darkGreen)
            Text(label)
                .font(.caption) // Small font size for the text
                .foregroundColor(darkGreen)
        }
    }
}

// Helper view for the Tags
struct TagView: View {
    let tag: String
    let color: Color
    
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)

    var body: some View {
        Text(tag)
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundColor(darkGreen)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(color)
            .cornerRadius(5)
    }
}

// MARK: - Preview
struct RecommendationView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendationView()
    }
}
