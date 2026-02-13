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
                    .stroke(isSelected ? bag.color : Color.clear, lineWidth: 2)
            )

            // Floating close button on top of preview
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.hierarchical)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 28, height: 28)
                    )
            }
            .padding(8)
        }
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
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()

        BagCardView(
            bag: Bag.sampleBags[0],
            bagIndex: 0,
            totalBags: 4,
            isSelected: true,
            onClose: {},
            onTap: {}
        )
        .padding()
    }
}
