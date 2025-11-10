//
//  ContentView.swift
//  leafbud-frontend
//
//  Created by Khanh Nguyen on 11/5/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    
    var body: some View {
        MainView()
        .onAppear {
            Task { await plantInst.fetchData() }
        }
    }
}

#Preview {
    ContentView()
}
