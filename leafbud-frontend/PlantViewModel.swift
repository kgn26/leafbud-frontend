//
//  PlantViewModel.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/9/25.
//

import Foundation
import Combine


struct Plant: Identifiable, Codable {
    let id: UUID
    let commonName: String
    let imageUrl: String?
    let lightPref: String
    let difficulty: String
    let waterInt: Int
    let mistInt: Int
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
//    @EnvironmentObject private var auth: AuthViewModel
    
    @Published var user: User?
    @Published var userPlant: PlantInstance?
    @Published var plantInfo: Plant?
    @Published var isLoading: Bool = true
    
    @ObservationIgnored let username = "tester00"
    @ObservationIgnored let apiUrl: String = "https://leafbud.vercel.app/api"
    
    private init() {}
    
    func fetchData() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        print("Fetching user...")
        await fetchUser(username: self.username)
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
}
