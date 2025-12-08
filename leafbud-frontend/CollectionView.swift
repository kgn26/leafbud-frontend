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

struct CollectionView: View {
    @State private var isLoading: Bool = false
    private let plantCollection: [Plant] = [
        Plant(
            id: UUID(uuidString: "2531136c-1363-4ec5-9287-2f9d8bcee2a7")!,
            commonName: "Aloe Vera",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/aloe_vera.png",
            lightPref: "BRIGHT",
            difficulty: "EASY",
            waterInt: 10,
            mistInt: nil,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 120,
            petToxic: true,
            tags: ["skin care", "soothing"],
            size: "S",
            soilType: "FAST_DRAINING",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "0ab3001f-df17-4b58-b1a3-76ccc1c2ef0f")!,
            commonName: "Areca Palm",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/areca_palm.png",
            lightPref: "BRIGHT",
            difficulty: "MODERATE",
            waterInt: 5,
            mistInt: 2,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 180,
            petToxic: false,
            tags: ["humidifier", "tropical breeze"],
            size: "L",
            soilType: "MOISTURE_HOLDING",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "f4847d6b-15bf-4c58-9ddf-58896461bd3a")!,
            commonName: "Boston Fern",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/boston_fern.png",
            lightPref: "LOW",
            difficulty: "MODERATE",
            waterInt: 3,
            mistInt: 1,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 120,
            petToxic: false,
            tags: ["lush green", "Victorian charm"],
            size: "M",
            soilType: "MOISTURE_HOLDING",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "e86ec03f-6a27-411f-b6dd-a730031c04e2")!,
            commonName: "Cast Iron Plant",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/cast_iron_plant.png",
            lightPref: "LOW",
            difficulty: "EASY",
            waterInt: 10,
            mistInt: nil,
            fertilizeInt: 60,
            repotInt: 365,
            pruneInt: 180,
            petToxic: false,
            tags: ["hardy", "low effort"],
            size: "S",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "67e74936-1a6d-43c9-9550-ba53b9e5cf37")!,
            commonName: "Chinese Evergreen",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/chinese_evergreen.png",
            lightPref: "LOW",
            difficulty: "EASY",
            waterInt: 10,
            mistInt: 3,
            fertilizeInt: 45,
            repotInt: 365,
            pruneInt: 180,
            petToxic: true,
            tags: ["feng shui", "low light"],
            size: "S",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:54:54.050Z"
        ),
        Plant(
            id: UUID(uuidString: "a0c712b3-81ea-4f2c-9f74-b4ed620b03da")!,
            commonName: "Desert Rose",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/desert_rose.png",
            lightPref: "BRIGHT",
            difficulty: "MODERATE",
            waterInt: 7,
            mistInt: nil,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 120,
            petToxic: true,
            tags: ["succulent", "pink blooms"],
            size: "S",
            soilType: "FAST_DRAINING",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "b6b8ce80-aee2-42bc-826d-f4fa2febe3c4")!,
            commonName: "Echeveria",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/echeveria.png",
            lightPref: "BRIGHT",
            difficulty: "EASY",
            waterInt: 5,
            mistInt: nil,
            fertilizeInt: 45,
            repotInt: 365,
            pruneInt: 120,
            petToxic: false,
            tags: ["rosette", "popular"],
            size: "S",
            soilType: "FAST_DRAINING",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "197d19d0-1834-4d39-bcb4-20ca3cf616cd")!,
            commonName: "Fiddle Leaf Fig",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/fiddle_leaf_fig.png",
            lightPref: "BRIGHT",
            difficulty: "CHALLENGING",
            waterInt: 5,
            mistInt: 2,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 90,
            petToxic: true,
            tags: ["indoor tree", "dramatic"],
            size: "L",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "c8bf3f5c-c894-46d9-b5e0-85fdeb897c2b")!,
            commonName: "Jade Plant",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/jade_plant.png",
            lightPref: "BRIGHT",
            difficulty: "EASY",
            waterInt: 14,
            mistInt: nil,
            fertilizeInt: 60,
            repotInt: 365,
            pruneInt: 120,
            petToxic: true,
            tags: ["good luck", "money tree"],
            size: "M",
            soilType: "FAST_DRAINING",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "ed7cbc40-1f31-47ec-818a-a11e9a6f1d44")!,
            commonName: "Lucky Bamboo",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/lucky_bamboo.png",
            lightPref: "LOW",
            difficulty: "EASY",
            waterInt: 5,
            mistInt: 2,
            fertilizeInt: 45,
            repotInt: 365,
            pruneInt: 180,
            petToxic: false,
            tags: ["good luck", "zen"],
            size: "M",
            soilType: "MOISTURE_HOLDING",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "cbb73940-f155-4029-8e9b-cff8f76e0ac7")!,
            commonName: "Monstera Deliciosa",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/monstera_deliciosa.png",
            lightPref: "BRIGHT",
            difficulty: "MODERATE",
            waterInt: 7,
            mistInt: 2,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 120,
            petToxic: true,
            tags: ["swiss cheese", "statement"],
            size: "L",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "c29fd622-f83c-45c4-8bf4-d00f4511a3f9")!,
            commonName: "Peace Lily",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/peace_lily.png",
            lightPref: "LOW",
            difficulty: "MODERATE",
            waterInt: 7,
            mistInt: 2,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 180,
            petToxic: true,
            tags: ["peace", "blooming"],
            size: "M",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "1177e3b7-bff2-4dfc-939a-60f938cbef35")!,
            commonName: "Ponytail Palm",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/ponytail_palm.png",
            lightPref: "BRIGHT",
            difficulty: "EASY",
            waterInt: 10,
            mistInt: nil,
            fertilizeInt: 60,
            repotInt: 365,
            pruneInt: 120,
            petToxic: false,
            tags: ["water saver", "bonsai vibe"],
            size: "M",
            soilType: "FAST_DRAINING",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "415eed91-2276-4ff6-ad89-310b5b2fa51b")!,
            commonName: "Pothos",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/pothos.png",
            lightPref: "LOW",
            difficulty: "EASY",
            waterInt: 7,
            mistInt: 3,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 120,
            petToxic: true,
            tags: ["fast grower", "vining"],
            size: "M",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "06a4cbf1-ef57-49fb-bff0-058f2ed3bbd2")!,
            commonName: "Rubber Plant",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/rubber_plant.png",
            lightPref: "BRIGHT",
            difficulty: "EASY",
            waterInt: 7,
            mistInt: 3,
            fertilizeInt: 60,
            repotInt: 365,
            pruneInt: 120,
            petToxic: true,
            tags: ["natural rubber", "bold"],
            size: "L",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "8db61183-e3db-4c6a-9323-8bd2a53ccdbf")!,
            commonName: "Rubber Tree",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/rubber_tree.png",
            lightPref: "BRIGHT",
            difficulty: "EASY",
            waterInt: 7,
            mistInt: 3,
            fertilizeInt: 60,
            repotInt: 365,
            pruneInt: 120,
            petToxic: true,
            tags: ["large tree", "latex"],
            size: "M",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "d1688686-5ba4-4190-8c47-5487f61c6057")!,
            commonName: "Snake Plant",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/snake_plant.png",
            lightPref: "LOW",
            difficulty: "EASY",
            waterInt: 14,
            mistInt: nil,
            fertilizeInt: 60,
            repotInt: 365,
            pruneInt: 180,
            petToxic: true,
            tags: ["air purifier", "night oxygen"],
            size: "M",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "edadd1dc-d722-4f5c-bd82-cca3d4093253")!,
            commonName: "Spider Plant",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/spider_plant.png",
            lightPref: "LOW",
            difficulty: "EASY",
            waterInt: 7,
            mistInt: 3,
            fertilizeInt: 30,
            repotInt: 365,
            pruneInt: 120,
            petToxic: false,
            tags: ["air purifier", "hanging charm"],
            size: "S",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "1ac745e1-8e39-46e6-94d5-c526481de9b4")!,
            commonName: "Yucca",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/yucca.png",
            lightPref: "BRIGHT",
            difficulty: "MODERATE",
            waterInt: 10,
            mistInt: nil,
            fertilizeInt: 45,
            repotInt: 365,
            pruneInt: 120,
            petToxic: true,
            tags: ["drought tough", "fibers"],
            size: "L",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        ),
        Plant(
            id: UUID(uuidString: "db2b4760-970f-4e90-b20e-2c6ab712a07d")!,
            commonName: "ZZ Plant",
            imageUrl: "https://sltizebsbcensfkzuaal.supabase.co/storage/v1/object/public/avatars/zz_plant.png",
            lightPref: "LOW",
            difficulty: "EASY",
            waterInt: 14,
            mistInt: nil,
            fertilizeInt: 60,
            repotInt: 365,
            pruneInt: 180,
            petToxic: true,
            tags: ["wax leaves", "neglect proof"],
            size: "M",
            soilType: "WELL_BALANCED",
            createdAt: "2025-10-16T20:53:41.938Z",
            updatedAt: "2025-10-16T20:53:41.938Z"
        )
    ]
    
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
                                ForEach(plantCollection, id: \.id) { plant in
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
            }
        }
    }
}


// ===================================================
// 3. REUSABLE PLANT CARD COMPONENT
// ===================================================

struct PlantCollectionCard: View {
    // Takes ColPlant directly
    let plant: Plant
    
    
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
            
            AsyncImage(url: URL(string: plant.imageUrl ?? "")) { phase in
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
