//
//  CollectionView.swift
//  leafbud-frontend
//
//  Created by Stacey Chen on 12/7/25.
//

import SwiftUI
import Foundation
import Combine
import Auth

// ===================================================
// 1. DATA MODEL (Fetching all available plants)
// ===================================================

// Note: Using a structure that assumes the API returns a list of plant objects.
struct CollectionResponse: Codable {
    let ok: Bool
    let count: Int
    let total: Int
    let results: [ColPlant]
}

// Data model for a single plant
struct ColPlant: Codable {
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

class CollectionStore: ObservableObject {
    static let shared = CollectionStore()
    
    private init() {}
    
    // Holds all plants fetched from the database
    @Published var availablePlants: [ColPlant] = []
    @ObservationIgnored let apiUrl: String = "https://leafbud.vercel.app/api"
    @ObservationIgnored let auth: AuthViewModel = AuthViewModel.shared
    
    // Function to fetch all plants from the general plant database
    func fetch_all_plants() async {
        // Assuming there is a general endpoint to get all plants
        let fetchUrl = "\(apiUrl)/plants"
        guard let url = URL(string: fetchUrl) else {
            print("Fetch Instance error: Invalid URL")
            return
        }
        
        // Create a simple GET request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode == 200 else {
                print("Fetch Instance error: Invalid response or bad status")
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(CollectionResponse.self, from: data)
            guard decodedResponse.ok else {
                print("Fetch Instance error: Response not okay")
                return
            }
    // Store the results (which are now just ColPlant objects)
            self.availablePlants = decodedResponse.results
        } catch {
            print("Fetch Instance error: \(error)")
        }
    }
}


// ===================================================
// 2. MAIN VIEW
// ===================================================

struct CollectionView: View {
    @StateObject private var store = CollectionStore.shared
    @State private var isLoading: Bool = false
    
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)
    // let cardGreen = Color(red: 216/255, green: 227/255, blue: 216/255)
    let lightBgColor = Color(red: 236/255, green: 240/255, blue: 234/255)
    
    //    var body: some View {
    //        NavigationStack {
    //            ZStack {
    //                lightBgColor.ignoresSafeArea()
    //
    //                VStack(alignment: .leading, spacing: 10) {
    //
    //                    Spacer().frame(maxHeight: 50)
    //
    //                    Text("Plant Collection")
    //                        .font(.largeTitle)
    //                        .fontWeight(.bold)
    //                        .foregroundColor(darkGreen)
    //                        .padding(.horizontal, 25)
    //                        .padding(.bottom, 20)
    //
    //                    // Display a loading indicator if needed
    //                    if isLoading {
    //                        ProgressView("Loading Plants...")
    //                            .foregroundColor(darkGreen)
    //                    } else {
    //                        ScrollView {
    //                            // Use availablePlants array
    //                            VStack(spacing: 20) {
    //                                ForEach(store.availablePlants, id: \.id) { plant in
    //                                    PlantCollectionCard(plant: plant) // isSelected removed from collection view
    //                                        .onTapGesture {
    //                                            print("Tapped \(plant.commonName) for details.")
    //                                        }
    //                                }
    //                            }
    //                            .padding(.horizontal, 25)
    //                            .padding(.bottom, 50)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        .onAppear {
    //            Task {
    //                isLoading = true
    //                await store.fetch_all_plants()
    //                isLoading = false
    //            }
    //        }
    //    }
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                lightBgColor.ignoresSafeArea()
                VStack(spacing: 0) {
                    // Title Text (Centered and styled from the image)
                    Text("Plant Collection")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(darkGreen)
                        .padding(.top, 50) // Adjust top padding to position title
                        .padding(.bottom, 20)
                    
                    // Display content
                    if isLoading{
                        ProgressView("Loading Plants...")
                            .foregroundColor(darkGreen)
                            .padding(.top, 100)
                    }
                    else {
                        ScrollView{
                            VStack(spacing: 20) {
                                ForEach(store.availablePlants, id: \.id) { plant in
                                    PlantCollectionCard(plant: plant)
                                        .onTapGesture {
                                            print("Tapped \(plant.commonName) for details.")
                                        }
                                }
                            }
                            .padding(.horizontal, 25)
                            .padding(.bottom, 50)
                        }
                        
                    }
                }
                .onAppear {
                    Task {
                        isLoading = true
                        await store.fetch_all_plants()
                        isLoading = false
                    }
                }
            }
        }
    }
}


// ===================================================
// 3. REUSABLE PLANT CARD COMPONENT
// ===================================================

struct PlantCollectionCard: View {
    // Takes ColPlant directly
    let plant: ColPlant
    
    
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)
    let cardGreen = Color(red: 216/255, green: 227/255, blue: 216/255)
    let tagGreen = Color(red: 173/255, green: 205/255, blue: 173/255)

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text(plant.commonName)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(darkGreen)
                    .padding(.bottom, 8)
                
                HStack(alignment: .top, spacing: 15) {
                    VStack(alignment: .leading, spacing: 4) {
                        CareDetailRow(icon: "clock.fill", label: plant.difficulty)
                        CareDetailRow(icon: "ruler.fill", label: plant.size)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        CareDetailRow(icon: "sun.max.fill", label: plant.lightPref)
                        CareDetailRow(icon: "triangle.fill", label: plant.petToxic ? "Toxic" : "Non-Toxic")
                    }
                }
                .padding(.bottom, 15)
                
                HStack(spacing: 8) {
                    ForEach(plant.tags.prefix(2), id: \.self) { tag in
                        TagsView(tag: tag, color: tagGreen)
                    }
                    Text("+5 more")
                        .font(.caption2)
                        .foregroundColor(darkGreen)
                }
            }
            
            Spacer()
            
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
        .background(cardGreen)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
    }
}


// Helper view for a single detail row (Icon + Text)
struct CareDetail: View {
    let icon: String
    let label: String
    
    let darkGreen = Color(red: 53/255, green: 79/255, blue: 50/255)

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(darkGreen)
            Text(label)
                .font(.caption)
                .foregroundColor(darkGreen)
        }
    }
}

// Helper view for the Tags
struct TagsView: View {
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

// ===================================================
// 4. PREVIEW PROVIDER
// ===================================================

struct CollectionView_Previews: PreviewProvider {
    // The CollectionView no longer needs SurveyData, so the preview is simpler.
    static var previews: some View {
        CollectionView()
    }
}
