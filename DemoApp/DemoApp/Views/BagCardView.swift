//
//  BagCardView.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

struct BagCardView: View {
    let bag: Bag
    let bagIndex: Int
    let totalBags: Int
    let isSelected: Bool
    let namespace: Namespace.ID
    let onClose: () -> Void
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                // Full-bleed screen preview that covers entire card
                BagScreenView(
                    bag: bag,
                    bagIndex: bagIndex,
                    totalBags: totalBags
                )
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .scaleEffect(0.47) // Increased scale to fill card completely
                .offset(y: 75) // Adjusted offset for better centering
                .frame(width: 185, height: 260)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2.5)
                )

                // Floating close button on top of preview
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(width: 18, height: 18)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.9))
                        )
                }
                .padding(6)
            }
            .matchedGeometryEffect(
                id: bag.id,
                in: namespace
            )
            .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)

            // Bag title below card
            Text(bag.name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
                onTap()
            }
        }
    }
}

#Preview {
    @Previewable @Namespace var namespace

    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()

        BagCardView(
            bag: Bag.sampleBags[0],
            bagIndex: 0,
            totalBags: 4,
            isSelected: true,
            namespace: namespace,
            onClose: {},
            onTap: {}
        )
        .padding()
    }
}
