//
//  PlantLocal.swift
//  leafbud-frontend
//
//  Created by Khanh Nguyen on 11/10/25.
//

import Foundation
import SwiftData

@Model
final class PlantLocal {
    @Attribute(.unique) var id: String           // Same as plant instance ID
    var nickname: String
    var commonName: String
    var imageURL: String?
    var lastUpdated: Date
    
    init(id: String, nickname: String, commonName: String, imageURL: String?) {
        self.id = id
        self.nickname = nickname
        self.commonName = commonName
        self.imageURL = imageURL
        self.lastUpdated = .now
    }
}

@MainActor
enum SwiftDataManager {
    static let container: ModelContainer = {
        do {
            let config = ModelConfiguration(for: PlantLocal.self)
            return try ModelContainer(for: PlantLocal.self, configurations: config)
        } catch {
            fatalError("❌ Failed to create container: \(error)")
        }
    }()

    static var context: ModelContext {
        container.mainContext
    }
}
