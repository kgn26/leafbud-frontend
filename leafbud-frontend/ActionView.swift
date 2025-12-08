//
//  ActionView.swift
//  leafbud-frontend
//
//  Created by Khanh Nguyen on 12/6/25.
//

import SwiftUI

enum Action: Identifiable {
    case water
    case mist
    case prune
    case fertilize
    case repot
    
    var id: String {
        type
    }
    
    var description: String {
        switch self {
        case .water:
            return "Watering"
        case .mist:
            return "Misting"
        case .prune:
            return "Pruning"
        case .fertilize:
            return "Fertilizing"
        case .repot:
            return "Repotting"
        }
    }
    
    var type: String {
        switch self {
        case .water:
            return "WATER"
        case .mist:
            return "MIST"
        case .prune:
            return "PRUNE"
        case .fertilize:
            return "FERTILIZE"
        case .repot:
            return "REPOT"
        }
    }
    
    var icon: String {
        switch self {
        case .water:
            return "wateringIcon"
        case .mist:
            return "mistingIcon"
        case .prune:
            return "pruningIcon"
        case .fertilize:
            return "soilIcon"
        case .repot:
            return "repotIcon"
        }
    }
    
    var color: Color {
        switch self {
        case .water:
            return .blue
        case .mist:
            return .blue
        case .prune:
            return .red
        case .fertilize:
            return .yellow
        case .repot:
            return .orange
        }
    }
}

struct ActionView: View {
    @Environment(\.dismiss) private var dismiss
    let action: Action
    let onDismiss: () -> Void
    
    @State private var progress: CGFloat = 0
    @State private var isComplete: Bool = false
    
    var body: some View {
        ZStack {
            Color(.bgGreen)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                ZStack {
                    // Progress Ring
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 3), value: progress)
                    
                    // Icon or Checkmark
                    if isComplete {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.iconGrn)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        Image(action.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                    }
                }
                
                if isComplete {
                    Text("Done!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textGreen)
                    HStack(spacing: 4) {
                        Text("You earned 1")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.textGreen)
                        Image("token")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                } else {
                    Text("\(action.description) your buddy...")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textGreen)
                }
            }
        }
        .task {
            // Animate progress for 3 seconds
            progress = 0
            isComplete = false
            withAnimation(.linear(duration: 3)) {
                progress = 1
            }
            
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            withAnimation(.spring()) {
                isComplete = true
            }
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            onDismiss()
        }
    }
}

#Preview {
    ActionView(action: .water) {}
}
