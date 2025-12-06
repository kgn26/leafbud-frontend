//
//  PlantViewModel.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/9/25.
//

import Foundation
import Combine
import Auth
import SwiftData


struct Plant: Identifiable, Codable {
    let id: UUID
    let commonName: String
    let imageUrl: String?
    let lightPref: String
    let difficulty: String
    let waterInt: Int
    let mistInt: Int?
    let fertilizeInt: Int
    let repotInt: Int
    let pruneInt: Int
    let petToxic: Bool
    let tags: [String]
    let size: String
    let soilType: String
    let createdAt: String
    let updatedAt: String
}

struct PlantInstance: Codable {
    let id: UUID
    let userId: UUID
    let plantId: UUID
    let nickname: String?
    let location: String?
    let createdAt: String
    let updatedAt: String
    let carePlan: [String: CareTask]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case plantId = "plant_id"
        case nickname
        case location
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case carePlan = "care_plan"
    }
}

struct CareTask: Codable {
    let optional: Bool
    let dueIn: Int
    
    enum CodingKeys: String, CodingKey {
        case optional
        case dueIn = "due_in"
    }
}

struct User: Codable {
    let id: UUID
    let firstName: String
    let lastName: String
    let username: String
    let avatarUrl: String?
    let lastUpdated: String?
    let plantInstId: UUID?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case avatarUrl = "avatar_url"
        case lastUpdated = "last_updated"
        case plantInstId = "plant_instance_id"
    }
}

struct PlantListResponse: Codable {
    let ok: Bool
    let plants: [Plant]
}

struct PlantResponse: Codable {
    let ok: Bool
    let plant: Plant
}

struct PlantInstanceResponse: Codable {
    let ok: Bool
    let plant: PlantInstance
}

struct UserResponse: Codable {
    let ok: Bool
    let userInfo: User?
}

@MainActor
final class PlantInstViewModel: ObservableObject {
    static let shared = PlantInstViewModel()
    private var auth: AuthViewModel = AuthViewModel.shared
    
    let plantCollection: [Plant] = [
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
    
    @Published var user: User?
    @Published var userPlant: PlantInstance?
    @Published var plantInfo: Plant?
    @Published var isLoading: Bool = true
    
    private let modelContext = SwiftDataManager.context
    private var localPlant: PlantLocal?
    
    @ObservationIgnored let apiUrl: String = "https://leafbud.vercel.app/api"
    @ObservationIgnored var loadedFromCache: Bool = false
    
    private init() {}
    
    func fetchData() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        loadLocalPlant()
        if self.loadedFromCache, let cached = self.localPlant {
            // Hydrate partial info into userPlant and plantInfo so UI has something to display
            self.userPlant = PlantInstance(
                id: UUID(uuidString: cached.id) ?? UUID(),
                userId: UUID(),  // dummy placeholders
                plantId: UUID(),
                nickname: cached.nickname,
                location: nil,
                createdAt: "",
                updatedAt: "",
                carePlan: nil
            )
            
            self.plantInfo = Plant(
                id: UUID(),  // dummy placeholders
                commonName: cached.commonName,
                imageUrl: cached.imageURL,
                lightPref: "",
                difficulty: "",
                waterInt: 0,
                mistInt: nil,
                fertilizeInt: 0,
                repotInt: 0,
                pruneInt: 0,
                petToxic: false,
                tags: [],
                size: "",
                soilType: "",
                createdAt: "",
                updatedAt: ""
            )
            
            // Prefetch image
            if let imageUrl = cached.imageURL, let url = URL(string: imageUrl) {
                let _ = try? await URLSession.shared.data(from: url)
            }
            
            // UI can start rendering immediately
            self.isLoading = false
            print("🌿 Hydrated userPlant and plantInfo from local cache")
        }
        
        var username = ""
        if case let .string(user) = auth.user?.userMetadata["username"] {
            username = user
        }
        print("Fetching user...")
        await fetchUser(username: username)
        print(self.user?.username ?? "No user")
        print(self.user?.plantInstId ?? "No plant associated with this user")
        
        if let user = self.user, let instance = user.plantInstId {
            print("Fetching plant instance")
            await fetchPlantInstance(instanceId: instance)
            
            if let plantId = self.userPlant?.plantId {
                await fetchPlant(plantId: plantId)
                if let imageUrl = self.plantInfo?.imageUrl, let url = URL(string: imageUrl) {
                    let _ = try? await URLSession.shared.data(from: url)
                }
            }
            
            if let instance = user.plantInstId,
               let nickname = self.userPlant?.nickname,
               let info = self.plantInfo {
                self.saveLocalPlant(
                    instanceId: instance.uuidString,
                    nickname: nickname,
                    commonName: info.commonName,
                    imageURL: info.imageUrl
                )
            }
        }
    }
    
    func fetchUser(username: String) async {
        let fetchUrl = "\(apiUrl)/users/\(username)"
        guard let url = URL(string: fetchUrl) else {
            print("Fetch Instance error: Invalid URL")
            return
        }
        
        // create a request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpsResponse = response as? HTTPURLResponse else {
                print("Fetch Instance error: Invalid response type")
                return
            }
            
            if httpsResponse.statusCode != 200 {
                print("Fetch Instance error: Bad status \(httpsResponse.statusCode)")
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
            guard decodedResponse.ok else {
                print("Fetch Instance error: Response not decodable")
                return
            }
            self.user = decodedResponse.userInfo
            print("Successfully fetched user \(username)")
        } catch {
            print("Fetch Instance error: \(error)")
        }
    }
    
    func fetchPlant(plantId: UUID) async {
        let fetchUrl = "\(apiUrl)/plants/\(plantId)"
        guard let url = URL(string: fetchUrl) else {
            print("Fetch Instance error: Invalid URL")
            return
        }
        
        // create a request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpsResponse = response as? HTTPURLResponse else {
                print("Fetch Instance error: Invalid response type")
                return
            }
            
            if httpsResponse.statusCode != 200 {
                print("Fetch Instance error: Bad status \(httpsResponse.statusCode)")
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(PlantResponse.self, from: data)
            guard decodedResponse.ok else {
                print("Fetch Instance error: Response not decodable")
                return
            }
            self.plantInfo = decodedResponse.plant
        } catch {
            print("Fetch Instance error: \(error)")
        }
    }
    
    func fetchPlantInstance(instanceId: UUID) async {
        let fetchUrl = "\(apiUrl)/instances/\(instanceId)"
        guard let url = URL(string: fetchUrl) else {
            print("Fetch Instance error: Invalid URL")
            return
        }
        
        // create a request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpsResponse = response as? HTTPURLResponse else {
                print("Fetch Instance error: Invalid response type")
                return
            }
            
            if httpsResponse.statusCode != 200 {
                print("Fetch Instance error: Bad status \(httpsResponse.statusCode)")
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(PlantInstanceResponse.self, from: data)
            guard decodedResponse.ok else {
                print("Fetch Instance error: Response not decodable")
                return
            }
            self.userPlant = decodedResponse.plant
        } catch {
            print("Fetch Instance error: \(error)")
        }
    }
    
    func loadLocalPlant() {
        let descriptor = FetchDescriptor<PlantLocal>()
        if let cached = try? modelContext.fetch(descriptor).first {
            self.localPlant = cached
            self.loadedFromCache = true
            print("✅ Loaded cached plant: \(cached.nickname)")
        } else {
            print("❌ No cached plant found for current user")
        }
    }
    
    func saveLocalPlant(instanceId: String, nickname: String, commonName: String, imageURL: String?) {
        // remove any old entry for this instanceId
        let descriptor = FetchDescriptor<PlantLocal>(
            predicate: #Predicate { $0.id == instanceId }
        )
        if let existing = try? modelContext.fetch(descriptor).first {
            modelContext.delete(existing)
        }
        
        let local = PlantLocal(id: instanceId, nickname: nickname, commonName: commonName, imageURL: imageURL)
        modelContext.insert(local)
        try? modelContext.save()
        self.localPlant = local
        print("💾 Saved plant locally: \(nickname)")
    }
}
