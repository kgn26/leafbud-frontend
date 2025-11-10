//
//  StoreView.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/8/25.
//

import SwiftUI

struct ItemCard: View {
    let imageName : String?
    let cost : Int
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.secondaryGrn)
                .frame(width: 170, height: 170)
            
            if let imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
            }
            
            VStack {
                HStack(spacing: 4) {
                    Image("token")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                    Text("x \(cost)")

                }
                
            }
            .frame(width: 170, height: 150, alignment: .bottom)
        }
    }
    
}

public struct StoreView: View {
    public var body: some View {
        VStack(spacing: 25) {
            Image("tokenCounter")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .padding(.top, 10)
                .overlay(
                    Text("001")
                        .font(.headline)
                        .offset(x: 17, y: 5)
                )
            
            Text("Accessory Store")
                .font(.title)
                .bold()
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        ItemCard(imageName: "hatDeco", cost: 1)
                        ItemCard(imageName: "", cost: 2)
                    } // HStack
                    
                    HStack(spacing: 20) {
                        ItemCard(imageName: "", cost: 3)
                        ItemCard(imageName: "", cost: 4)
                    } // HStack

                    
                } // VStack
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.backgroundGrn)
    }
}

#Preview {
    StoreView()
}
