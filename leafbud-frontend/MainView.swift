//
//  MainView.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/6/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    @State var currentCareType : Action? = nil
    @State var isUpdating : Bool = false
    @State var numCoins: Int8 = 0
    
    var body: some View {
        ZStack {
            // Main content always in the tree
            TabView {
                Tab("", systemImage: "house") {
                    HomeView(isUpdating: $isUpdating, currentCareType: $currentCareType)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Color(.navbarGrn), for: .tabBar)
                }
                
                Tab("", systemImage: "leaf") {
                    ProfileView()
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Color(.navbarGrn), for: .tabBar)
                }
                
                Tab("", systemImage: "cart") {
                    StoreView(numCoins: $numCoins)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Color(.navbarGrn), for: .tabBar)
                }
                
                Tab("", systemImage: "plus.square") {
                    CollectionView()
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Color(.navbarGrn), for: .tabBar)
                }
            }
            .tint(Color(.iconGrn))
            
            // Loading overlay
            if plantInst.isLoading {
                Color.backgroundGrn
                    .ignoresSafeArea()
                    .opacity(0.6)
                
                LoadingView()
            }
        }
        // ✅ Host the cover at a stable level
        .fullScreenCover(item: $currentCareType) { action in
            ActionView(action: action) {
                numCoins += 1
                isUpdating = false
                currentCareType = nil
            }
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Your plant buddy is getting milk...")
        }
    }
}

#Preview {
    MainView()
        .environmentObject(PlantInstViewModel.shared)
}
