//
//  ProfileView.swift
//  leafbud-frontend
//
//  Created by Victor Li on 11/7/25.
//

import SwiftUI

// Allows for Labels to be vertically stacked
struct MyCustomLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: 5) {
            configuration.icon
            configuration.title
        }
    }
}

// Allows for LabelStyle to take in a vertical param
// look into how this works later lol
extension LabelStyle where Self == MyCustomLabelStyle {
    static var vertical : Self {
        MyCustomLabelStyle()
    }
}

// <Content: View> allows text
struct VerticalLabel<Content: View> : View {
    let text: Content
    let imageName: String
    
    var body: some View {
        Label {
            text
                .multilineTextAlignment(.center)
        } icon: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
        }
            .labelStyle(.vertical)
    }
}

struct InfoCard<Content: View>: View {
    
    let title: String
    let cardColor: Color
    let vStkSpacing: CGFloat
    let content: Content
    
    init(title: String,
         cardColor: Color,
         vStkSpacing: CGFloat = 10,
         @ViewBuilder content: () -> Content) {
        self.title = title
        self.cardColor = cardColor
        self.vStkSpacing = vStkSpacing
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(cardColor)
                .frame(width: 350, height: 180)
//                .padding(.top, 10)
            
            VStack(spacing: vStkSpacing) {
                Text(title)
                    .font(.headline)
                
                content
            }
//            .padding()
//            .offset(x: 0, y: -5)
        }
    }
    
}

struct ProfileView: View {
    @EnvironmentObject private var plantInst: PlantInstViewModel
    var nextWatering: String {
        let nextDue = plantInst.userPlant?.carePlan?["WATER"]?.dueIn ?? 0
        switch nextDue {
        case 1: return "Tomorrow"
        case 0: return "Today"
        case -1: return "Yesterday"
        case ...(-2): return "\(abs(nextDue)) days late"
        default: return "in \(nextDue) days"
        }
    }
    var nextRepot: Int {
        return plantInst.userPlant?.carePlan?["REPOT"]?.dueIn ?? 0
    }
    var nextMisting: Int {
        return plantInst.userPlant?.carePlan?["MIST"]?.dueIn ?? 0
    }
    var nextPruning: Int {
        return plantInst.userPlant?.carePlan?["PRUNE"]?.dueIn ?? 0
    }
    var nextFertilizing: Int {
        return plantInst.userPlant?.carePlan?["FERTILIZE"]?.dueIn ?? 0
    }
    
    var body: some View {
        VStack {
            Image("profileCircle")
                .padding(.top, 100)
                .overlay(
                    AsyncImage(url: URL( string: plantInst.plantInfo?.imageUrl ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 70)
                                .offset(y: 45)
                        default:
                            Image("smilePlant")
                                .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .offset(y: 40)
                        }
                    }
                )
            Text(plantInst.userPlant?.nickname ?? "Plant Name")
                .font(.title)
                .bold()

            
            ScrollView {
                VStack(spacing: 15) {
                    InfoCard(
                        title: "Water",
                        cardColor: Color.primaryBlue,
                    ) {
                        HStack(spacing: 25) {
                            VerticalLabel(
                                text: (Text("Next watering\n")
                                       + Text("\(self.nextWatering)"))
                                .font(.caption),
                                imageName: "waterIcon"
                            )
                            
                            VerticalLabel(
                                text: Text("7\n")
                                    .font(.title)
                                    .bold()
                                + Text("Day Streak!")
                                    .font(.subheadline),
                                imageName: "waterIcon"
                            )
                            
                            
                            VerticalLabel(
                                text: (Text("Next ________\n")
                                       + Text("in __ days"))
                                .font(.caption),
                                imageName: "waterIcon"
                            )
                        }
                    }
                    
                    
                    InfoCard(
                        title: "Fertilizing",
                        cardColor: Color.secondaryGrn,
                        vStkSpacing: 20
                    ) {
                        HStack(spacing: 25) {
                            VerticalLabel(
                                text: (Text("Next ________\n")
                                       + Text("in __ days"))
                                .font(.caption),
                                imageName: "soilIcon"
                            )
                            
                        }
                    }
                    
                    InfoCard(
                        title: "Maintenance",
                        cardColor: Color.primaryOg,
                        vStkSpacing: 20
                    ) {
                        HStack(spacing: 25) {
                            VerticalLabel(
                                text: (Text("Next ________\n")
                                       + Text("in __ days"))
                                .font(.caption),
                                //                            .fontDesign(.serif),
                                imageName: "soilIcon"
                            )
                            
                        }
                    }
                    
                } // InfoCard VStack
            } // ScrollView
            .padding(.top, 10)
            .padding(.bottom, 100)
            .scrollIndicators(.hidden)
            
        } // Outer VStack
        .frame(maxWidth: .infinity, maxHeight: .infinity) // expand to fill screen
        .background(Color.backgroundGrn)
        .ignoresSafeArea()
    }
}

#Preview {
    ProfileView()
}
