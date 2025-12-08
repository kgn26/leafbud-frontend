//
//  LoginView.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/6/25.
//


import SwiftUI
import CoreLocation

struct PlantCareButton : View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    @Binding var isWatering : Bool
    @Binding var currentCareType : Action?
    
    let careType : Action
    let imageName : String
    
    let label : String
    let labelColor : Color
    let labelWidth : CGFloat
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(labelColor)
                    .frame(width: labelWidth, height: 50)
                
                Text(label)
                    .foregroundColor(.white)
                    .bold()
            }
            
            Button {
                currentCareType = careType
                Task {
                    if let instanceId = plantInst.userPlant?.id {
                        isWatering = true
                        await plantInst.updatePlantCare(instanceId: instanceId, type: careType.type)
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

struct ExpandablePlantCareMenu: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    @Binding var isUpdating : Bool
    @Binding var currentCareType : Action?
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 15) {
            if isExpanded {
                Group {
                    PlantCareButton(
                        isWatering: $isUpdating,
                        currentCareType: $currentCareType,
                        careType: .prune,
                        imageName: "pruningIcon",
                        label: "Prune",
                        labelColor: Color.iconOg,
                        labelWidth: 90
                    )
                    
                    PlantCareButton(
                        isWatering: $isUpdating,
                        currentCareType: $currentCareType,
                        careType: .repot,
                        imageName: "repotIcon",
                        label: "Repot",
                        labelColor: Color.iconOg,
                        labelWidth: 90
                    )
                    
                    PlantCareButton(
                        isWatering: $isUpdating,
                        currentCareType: $currentCareType,
                        careType: .fertilize,
                        imageName: "soilIcon",
                        label: "Fertilize",
                        labelColor: Color.iconGrn,
                        labelWidth: 105
                    )
                    
                    PlantCareButton(
                        isWatering: $isUpdating,
                        currentCareType: $currentCareType,
                        careType: .mist,
                        imageName: "mistingIcon",
                        label: "Mist",
                        labelColor: Color.iconBlue,
                        labelWidth: 85
                    )
                    
                    PlantCareButton(
                        isWatering: $isUpdating,
                        currentCareType: $currentCareType,
                        careType: .water,
                        imageName: "wateringIcon",
                        label: "Water",
                        labelColor: Color.iconBlue,
                        labelWidth: 100
                    )
                }
                // Moving up animation
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .padding(.trailing, 5)
                // Ensure the VStack is rendered on top of the Color.black (dimmed background) view
                .zIndex(1)
            }
            
            Button {
                withAnimation(.easeOut(duration: 0.25)) { // Use a slight bounce or ease-out curve
                    isExpanded.toggle()
                }
            } label: {
                Image("expandIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
            }
    
        }
    }
}


struct HomeView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    @EnvironmentObject private var locationManager: LocationManager
    @State private var isExpanded : Bool = false
    @Binding var isUpdating : Bool
    @Binding var currentCareType : Action?
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
                
                // 🌿 1. THE DIMMING OVERLAY
                if isExpanded {
                    Color.black
                        .opacity(0.4) // Adjust opacity for desired dimness (e.g., 0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            // Optional: Tap anywhere on the dimmed area to close the menu
                            withAnimation(.easeOut(duration: 0.25)) {
                                isExpanded = false
                            }
                        }
                        // Add animation for smooth appearance/disappearance
                        .transition(.opacity)
                }

                ExpandablePlantCareMenu(isUpdating: $isUpdating, currentCareType: $currentCareType)
                    .padding(.trailing, 20)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                
                
            }
            .onAppear {
                Task {
                    print("Getting weather info...")
                    if let location = locationManager.location {
                        print("Location found!")
                        let lat = location.latitude
                        let lon = location.longitude
                        await weatherInfo.fetchWeather(lat: lat, lon: lon)
                        print("Done, weather info fetched!")
                    }
                    print("That's it...")
                }
            }
            .onDisappear { print("HomeView disappeared ❌") }
        }
    }
}

//#Preview {
//    HomeView()
//}
