//
//  BagSwitcherButton.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

struct BagSwitcherButton: View {
    let bagCount: Int
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Stacked cards effect (similar to Safari tabs icon)
                ForEach(0..<min(3, bagCount), id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .frame(width: 56, height: 56)
                        .offset(
                            x: CGFloat(index) * -2,
                            y: CGFloat(index) * -4
                        )
                        .opacity(1.0 - Double(index) * 0.3)
                }

                // Main icon
                VStack(spacing: 2) {
                    Image(systemName: "square.stack.3d.up.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.blue.gradient)

                    Text("\(bagCount)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.primary)
                }
                .offset(x: -2, y: -4)
            }
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()

        VStack(spacing: 40) {
            BagSwitcherButton(bagCount: 1) {
                print("1 bag tapped")
            }

            BagSwitcherButton(bagCount: 4) {
                print("4 bags tapped")
            }

            BagSwitcherButton(bagCount: 10) {
                print("10 bags tapped")
            }
        }
    }
}
