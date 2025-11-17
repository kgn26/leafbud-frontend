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

struct CareUpdate: Codable {
    let id: UUID
    let instanceId: UUID
    let type: String
    let intervalDays: Int
    let lastCompletedAt: String?
    let graceDays: Int?
    let optional: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case instanceId = "instance_id"
        case type
        case intervalDays = "interval_days"
        case lastCompletedAt = "last_completed_at"
        case graceDays = "grace_days"
        case optional
    }
}

struct CareUpdateRequest: Codable {
    let instanceId: UUID
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case instanceId = "instance_id"
        case type
    }
}

struct CareUpdateResponse: Codable {
    let ok: Bool
    let result: CareUpdate
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
    
    @Published var user: User?
    @Published var userPlant: PlantInstance?
    @Published var plantInfo: Plant?
    @Published var isLoading: Bool = true
    
    // Plant care due dates
    @Published var nextWateringDue: String = "Optional"
    @Published var nextMistingDue: String = "Optional"
    @Published var nextFertilizingDue: String = "Optional"
    @Published var nextPruningDue: String = "Optional"
    @Published var nextRepottingDue: String = "Optional"
    
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
            
            // update watering + everything else after fetching
            self.updateCarePlan()
            print("Plant care plan has been updated")
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
    
    func updatePlantCare(instanceId: UUID, type: String) async {
        let fetchUrl = "\(apiUrl)/care/"
        guard let url = URL(string: fetchUrl) else {
            print("Fetch Instance error: Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let careUpdateRequest = CareUpdateRequest(instanceId: instanceId, type: type)
        guard let requestBody = try? JSONEncoder().encode(careUpdateRequest) else {
            print("updatePlantCare error: Cannot encode JSON")
            return
        }
        
        request.httpBody = requestBody

        print("================== URL Request ==================")
            
            // 1. URL and HTTP Method
            if let url = request.url?.absoluteString {
                print("URL: \(url)")
            }
            print("Method: \(request.httpMethod ?? "N/A")")
            
            // 2. HTTP Headers
            if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
                print("Headers:")
                for (key, value) in headers {
                    print("  \(key): \(value)")
                }
            } else {
                print("Headers: None")
            }
            
            // 3. HTTP Body (Payload)
            if let body = request.httpBody {
                // Attempt to convert Data body to a readable String
                if let bodyString = String(data: body, encoding: .utf8) {
                    print("Body (Decoded):")
                    print(bodyString)
                } else {
                    print("Body (Raw Data Size): \(body.count) bytes. Could not decode as UTF-8.")
                }
            } else {
                print("Body: None")
            }
            
            print("=================================================")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("updatePlantCare error: No HTTP response")
                return
            }
            
            if httpResponse.statusCode != 200 {
                print("updatePlantCare error: HTTP status code \(httpResponse.statusCode)")
                print("data: \(String(data: data, encoding: .utf8))")
                return
            }
            
            print("data: \(String(data: data, encoding: .utf8))")

            
            let decodedResponse = try JSONDecoder().decode(CareUpdateResponse.self, from: data)
            print("Reached here after decoding")
            guard decodedResponse.ok else {
                print("updatePlantCare error: Response not decodable.")
                return
            }
            
        } catch {
            print("Fetch Instance error: \(error)")
        }
        
    } // updatePlantCare
    
    private func updateCarePlan() {
        guard let carePlan = userPlant?.carePlan else { return }
        
        if let waterTask = carePlan["WATER"] {
            switch waterTask.dueIn {
            case 1: self.nextWateringDue = "Tomorrow"
            case 0: self.nextWateringDue = "Today"
            case -1: self.nextWateringDue =  "Yesterday"
            case ...(-2): self.nextWateringDue = "\(abs(waterTask.dueIn)) days late"
            default: self.nextWateringDue = "in \(waterTask.dueIn) days"
            }
        }
        
        if let mistTask = carePlan["MIST"] {
            switch mistTask.dueIn {
            case 1: self.nextMistingDue = "Tomorrow"
            case 0: self.nextMistingDue = "Today"
            case -1: self.nextMistingDue =  "Yesterday"
            case ...(-2): self.nextMistingDue = "\(abs(mistTask.dueIn)) days late"
            default : self.nextMistingDue = "in \(mistTask.dueIn) days"
            }
        }
        
        if let fertilizeTask = carePlan["FERTILIZE"] {
            switch fertilizeTask.dueIn {
            case 1: self.nextFertilizingDue = "Tomorrow"
            case 0: self.nextFertilizingDue = "Today"
            case -1: self.nextFertilizingDue =  "Yesterday"
            case ...(-2): self.nextFertilizingDue = "\(abs(fertilizeTask.dueIn)) days late"
            default : self.nextFertilizingDue = "in \(fertilizeTask.dueIn) days"
            }
        }
        
        if let pruneTask = carePlan["PRUNE"] {
            switch pruneTask.dueIn {
            case 1: self.nextPruningDue = "Tomorrow"
            case 0: self.nextPruningDue = "Today"
            case -1: self.nextPruningDue =  "Yesterday"
            case ...(-2): self.nextPruningDue = "\(abs(pruneTask.dueIn)) days late"
            default : self.nextPruningDue = "in \(pruneTask.dueIn) days"
            }
        }
        
        if let repotTask = carePlan["REPOT"] {
            switch repotTask.dueIn {
            case 1: self.nextRepottingDue = "Tomorrow"
            case 0: self.nextRepottingDue = "Today"
            case -1: self.nextRepottingDue =  "Yesterday"
            case ...(-2): self.nextRepottingDue = "\(abs(repotTask.dueIn)) days late"
            default : self.nextRepottingDue = "in \(repotTask.dueIn) days"
            }
        }
    }
}
