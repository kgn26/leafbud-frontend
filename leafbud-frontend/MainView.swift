//
//  ProfileView.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/6/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    
    var body: some View {
        if plantInst.isLoading {
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.backgroundGrn.ignoresSafeArea())
        } else {
            TabView {
                Tab("", systemImage: "house") {
                    HomeView()
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Color(.navbarGrn), for: .tabBar)
                }
                
                
                Tab("", systemImage: "leaf") {
                    ProfileView()
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Color(.navbarGrn), for: .tabBar)
                }
                
                Tab("", systemImage: "cart") {
                    StoreView()
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Color(.navbarGrn), for: .tabBar)
                }
                
                Tab("", systemImage: "plus.square") {
                    Text("Collection")
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                        .toolbarBackground(Color(.navbarGrn), for: .tabBar)
                }
            }
            //        .toolbarBackground(.visible, for: .automatic)
            //        .toolbarBackground(Color.green, for: .automatic)
            .tint(Color(.iconGrn))
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
