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
        ZStack(alignment: .topTrailing) {
            // Full-bleed screen preview that covers entire card
            BagScreenView(
                bag: bag,
                bagIndex: bagIndex,
                totalBags: totalBags
            )
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .scaleEffect(0.45) // Larger scale for better visibility
            .offset(y: 55) // Shift down to show top content better
            .frame(width: 160, height: 280)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )

            // Floating close button on top of preview
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
                    .frame(width: 20, height: 20)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.85))
                    )
            }
            .padding(8)
        }
        .matchedGeometryEffect(
            id: bag.id,
            in: namespace
        )
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)
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
