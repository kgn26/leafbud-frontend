//
//  LoginView.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/6/25.
//


import SwiftUI
import CoreLocation

struct plantCareButton : View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    @Binding var isWatering : Bool
    @Binding var currentCareType : String
    
    let careType : String
    let imageName : String
    
    var body: some View {
        Button {
            currentCareType = careType
            Task {
                if let instanceId = plantInst.userPlant?.id {
                    isWatering = true
                    await plantInst.updatePlantCare(instanceId: instanceId, type: careType)
                    isWatering = false
                    await plantInst.fetchData()
                }
            }
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
        }
        
    }
}

struct WeatherPillView: View {
    @ObservedObject var weather: WeatherViewModel
    var pillColor: Color {
        switch weather.weatherCode {
        case 0, 1:
            return Color.yellow.opacity(0.8)
        case 2:
            return Color.blue.opacity(0.6)
        case 3:
            return Color.gray.opacity(0.5)
        case 61, 63, 65:
            return Color.blue.opacity(0.4)
        default:
            return Color.black.opacity(0.25)
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Text(String(format: "%.1fºF", weather.temperature ?? 0.0))
                .foregroundColor(.white)
                .font(.headline)
                .bold()
            
            if let icon = weather.iconName {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }
            
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(
            Capsule().fill(pillColor)
        )
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct HomeView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    @EnvironmentObject private var locationManager: LocationManager
    @State private var isExpanded : Bool = false
    @State private var isUpdating : Bool = false
    @State private var currentCareType : String = ""
    @StateObject private var weatherInfo: WeatherViewModel = WeatherViewModel.shared
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                
                // Bottom color (covers entire background)
                Color.secondaryGrn
                    .ignoresSafeArea()
                
                // Top color (covers only a fraction of the height)
                Color.backgroundBlue
                    .frame(height: geo.size.height * 0.7) // 30% of screen height
                    .ignoresSafeArea(edges: .top)
                
                WeatherPillView(weather: weatherInfo)
                    .padding()
                
                AsyncImage(url: URL( string: plantInst.plantInfo?.imageUrl ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 160)
                            .position(x: geo.size.width / 2, y: geo.size.height * 0.5)
                    default:
                        Image("smilePlant")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200)
                            .position(x: geo.size.width / 2, y: geo.size.height * 0.6)
                    }
                } // AsyncImage
                
                if isUpdating {
                    Text("wowowow is \(currentCareType) rn")
                        .font(.title)
                        .bold()
                }
                
                VStack(spacing: 15) {
                    if isExpanded {
                        plantCareButton(
                            isWatering: $isUpdating,
                            currentCareType: $currentCareType,
                            careType: "PRUNE",
                            imageName: "pruningIcon")
                        
                        plantCareButton(
                            isWatering: $isUpdating,
                            currentCareType: $currentCareType,
                            careType: "REPOT",
                            imageName: "repotIcon")
                        
                        plantCareButton(
                            isWatering: $isUpdating,
                            currentCareType: $currentCareType,
                            careType: "FERTILIZE",
                            imageName: "soilIcon")
                        
                        plantCareButton(
                            isWatering: $isUpdating,
                            currentCareType: $currentCareType,
                            careType: "MIST",
                            imageName: "mistingIcon")
                        
                        plantCareButton(
                            isWatering: $isUpdating,
                            currentCareType: $currentCareType,
                            careType: "WATER",
                            imageName: "wateringIcon")
                    }
                    
                    Button {
                        isExpanded.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
                
            }
            .onAppear {
                Task {
                    if let location = locationManager.location {
                        let lat = location.latitude
                        let lon = location.longitude
                        await weatherInfo.fetchWeather(lat: lat, lon: lon)
                        print("Done, weather info fetched!")
                    }
                    
                }
            }
        }
    }
}

//#Preview {
//    HomeView()
//}
