//
//  RecommendationView.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 11/12/25.
//

import SwiftUI
import Foundation
import Combine
import Auth

// ===================================================
// 1. DATA MODEL (Placeholder for the recommended plants)
// ===================================================

// ===================================================
// RecommendationResponse Structs (for API decoding)
// ===================================================

struct RecommendationResponse: Codable {
    let ok: Bool
    let received: ReceivedInfo
    let count: Int
    let total: Int
    let results: [RecommendationResult]

    struct ReceivedInfo: Codable {
        let preferredLight: String
        let difficulty: String
        let hasPets: Bool
        let size: String
    }

    struct RecommendationResult: Codable {
        let plant: RecPlant
        let score: Int
    }
}


struct RecPlant: Codable {
    let id: UUID
    let commonName: String
    let imageUrl: String
    let lightPref: String
    let difficulty: String
    let petToxic: Bool
    let waterInt: Int
    let soilType: String
    let tags: [String]
    let size: String
}

class RecommendationStore: ObservableObject {
    static let shared = RecommendationStore()
    
    private init() {}
    
    @Published var recommendations: [RecommendationResponse.RecommendationResult] = []
    @ObservationIgnored let apiUrl: String = "https://leafbud.vercel.app/api"
    @ObservationIgnored let auth: AuthViewModel = AuthViewModel.shared
    
    func get_recommendations(surveyData: SurveyData) async  {
        let fetchUrl = "\(apiUrl)/recommend"
        guard let url = URL(string: fetchUrl) else {
            print("Fetch Instance error: Invalid URL")
            return
        }
        
        // create a request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Prepare body
        let body: [String: Any] = [
            "difficulty": surveyData.difficulty,
            "preferredLight": surveyData.lightPref,
            "size": surveyData.size,
            "hasPets": surveyData.hasPets
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpsResponse = response as? HTTPURLResponse else {
                print("Fetch Instance error: Invalid response type")
                return
            }
            
            if httpsResponse.statusCode != 200 {
                if let body = request.httpBody {
                    print(String(data: body, encoding: .utf8) ?? "No body")
                }
                print("Fetch Instance error: Bad status \(httpsResponse.statusCode)")
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(RecommendationResponse.self, from: data)
            guard decodedResponse.ok else {
                print("Fetch Instance error: Response not decodable")
                return
            }
            self.recommendations = decodedResponse.results
        } catch {
            print("Fetch Instance error: \(error)")
        }
    }
    
    func register_plant(plantId: UUID, nickname: String) async  {
        let fetchUrl = "\(apiUrl)/users/register"
        guard let url = URL(string: fetchUrl) else {
            print("Fetch Instance error: Invalid URL")
            return
        }
        
        // check if user exists
        guard let userId = auth.user?.id else {
            print("No user associated with this session")
            return
        }
        
        // create a request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Prepare body
        let body: [String: Any] = [
            "userId": userId.uuidString,
            "plantId": plantId.uuidString,
            "nickname": nickname,
            "location": ""
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpsResponse = response as? HTTPURLResponse else {
                print("Fetch Instance error: Invalid response type")
                return
            }
            
            if httpsResponse.statusCode != 200 {
                if let body = request.httpBody {
                    print(String(data: body, encoding: .utf8) ?? "No body")
                }
                print("Fetch Instance error: Bad status \(httpsResponse.statusCode)")
                return
            }
        } catch {
            print("Fetch Instance error: \(error)")
        }
    }
}

// ===================================================
// 2. MAIN VIEW
// ===================================================

struct RecommendationView: View {
    @StateObject private var store = RecommendationStore.shared
    @ObservedObject var surveyData: SurveyData
    @State private var selection: UUID? = nil
    @State private var nickname: String = ""
    @State private var isLoading: Bool = false
    
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
                            ForEach(store.recommendations, id: \.plant.id) { plant in
                                // Each card is wrapped in a button to simulate selection
                                Button(action: {
                                    print("Selected \(plant.plant.commonName). Navigating to completion screen.")
                                    selection = plant.plant.id
                                }) {
                                    PlantRecommendationCard(plant: plant.plant, isSelected: selection == plant.plant.id)
                                }
                                .buttonStyle(PlainButtonStyle()) // Remove default button highlight style
                            }
                        }
                        .padding(.horizontal, 25) // Pad the ScrollView content/
                        .padding(.bottom, 50) // Ensure space at the bottom of the list
                    }
                    // Nickname Input Field
                    Text("Let's pick a nickname for your plant buddy")
                        .padding(.horizontal, 25)
                    TextField("Enter name...", text: $nickname)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 10)
                    
                    // Submit Button
                    Button(action: {
                        print("Submit recommendations tapped.")
                        Task {
                            isLoading = true
                            await store.register_plant(plantId: selection!, nickname: nickname)
                            isLoading = false
                            await PlantInstViewModel.shared.fetchData()
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selection == nil || nickname.isEmpty ? Color.gray : darkGreen)
                                .cornerRadius(12)
                        } else {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selection == nil || nickname.isEmpty ? Color.gray : darkGreen)
                                .cornerRadius(12)
                        }
                    }
                    .disabled(selection == nil || nickname.isEmpty)
                    .padding(.horizontal, 25)
                    .padding(.bottom, 30)
                }
            }
        }
        .onAppear {
            Task {
                await store.get_recommendations(surveyData: surveyData)
            }
        }
    }
}

// ===================================================
// 3. REUSABLE PLANT CARD COMPONENT (UPDATED FOR 2x2 LAYOUT)
// ===================================================

struct PlantRecommendationCard: View {
    let plant: RecPlant
    let isSelected: Bool
    
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)
    let cardGreen = Color(red: 216/255, green: 227/255, blue: 216/255)
    let tagGreen = Color(red: 173/255, green: 205/255, blue: 173/255)

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            // Left side: Name, Details, and Tags
            VStack(alignment: .leading, spacing: 5) {
                
                // Plant Name
                Text(plant.commonName)
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
                        CareDetailRow(icon: "clock.fill", label: "\(plant.waterInt)")
                        CareDetailRow(icon: "ruler.fill", label: plant.size)
                    }
                    
                    // Column 2: Light and Toxicity
                    VStack(alignment: .leading, spacing: 4) {
                        CareDetailRow(icon: "sun.max.fill", label: plant.lightPref)
                        CareDetailRow(icon: "triangle.fill", label: plant.petToxic ? "Pet Toxic" : "Pet Safe")
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
            AsyncImage(url: URL(string: plant.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                default:
                    Image("smilePlant")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
            }
        }
        .padding(15)
        .background(isSelected ? cardGreen.opacity(0.6) : cardGreen)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 3)
        )
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
