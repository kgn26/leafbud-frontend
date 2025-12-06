//
//  WeatherViewModel.swift
//  leafbud-frontend
//
//  Created by Khanh Nguyen on 11/20/25.
//

import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    static let shared = WeatherViewModel()
    
    private init() {}
    
    struct Weather: Decodable {
        let time: String
        let interval: Int
        let temperature_2m: Double
        let weather_code: Int
    }

    struct WeatherResponse: Decodable {
        let ok: Bool
        let weather: Weather
    }

    @Published var temperature: Double?
    @Published var weatherCode: Int?
    @Published var iconName: String?

    func fetchWeather(lat: Double, lon: Double) async {
        print("Fetching weather info for \(lat), \(lon)")
        guard let url = URL(string: "https://leafbud.vercel.app/api/weather?lat=\(lat)&lon=\(lon)") else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)

            DispatchQueue.main.async {
                self.temperature = decoded.weather.temperature_2m
                self.weatherCode = decoded.weather.weather_code
                self.iconName = self.weatherIcon(decoded.weather.weather_code)
            }
        } catch {
            print("Weather fetch error:", error)
        }
    }

    private func weatherIcon(_ code: Int) -> String {
        switch code {
        case 0: return "sun.max.fill"
        case 1: return "sun.max"
        case 2: return "cloud.sun.fill"
        case 3: return "cloud.fill"
        case 45, 48: return "cloud.fog.fill"
        case 51, 53, 55: return "cloud.drizzle.fill"
        case 61, 63, 65: return "cloud.rain.fill"
        case 66, 67: return "cloud.sleet.fill"
        case 71, 73, 75, 77: return "cloud.snow.fill"
        case 80, 81, 82: return "cloud.heavyrain.fill"
        case 85, 86: return "cloud.snow.fill"
        case 95, 96, 99: return "cloud.bolt.rain.fill"
        default: return "questionmark"
        }
    }
}


