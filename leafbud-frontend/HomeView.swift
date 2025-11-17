//
//  LoginView.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/6/25.
//


import SwiftUI

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

struct HomeView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    @State private var isExpanded : Bool = false
    @State private var isUpdating : Bool = false
    @State private var currentCareType : String = ""
    
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
            
        }
    }
}

#Preview {
    HomeView()
}
