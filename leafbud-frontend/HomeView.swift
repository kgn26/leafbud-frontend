//
//  LoginView.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/6/25.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
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
                }
                    
            }
        }
    }
}

#Preview {
    HomeView()
}
