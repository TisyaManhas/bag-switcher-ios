//
//  BagCardView.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

struct BagCardView: View {
    let bag: Bag
    let isSelected: Bool
    let onClose: () -> Void
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 0) {
            // Close button
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
                        .background(
                            Circle()
                                .fill(.ultraThinMaterial)
                        )
                }
                .padding(8)
            }

            // Card content
            VStack(spacing: 12) {
                // Icon
                Image(systemName: bag.icon)
                    .font(.system(size: 40))
                    .foregroundStyle(bag.color.gradient)

                // Bag name
                Text(bag.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)

                // Item count and total
                VStack(spacing: 4) {
                    Text("\(bag.itemCount) items")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)

                    Text("$\(String(format: "%.2f", bag.totalAmount))")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.primary)
                }

                // Preview items
                if !bag.items.isEmpty {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(bag.items.prefix(2)) { item in
                            Text("• \(item.name)")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        if bag.items.count > 2 {
                            Text("• +\(bag.items.count - 2) more")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 16)
        }
        .frame(height: 280)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? bag.color : Color.clear, lineWidth: 2)
                )
        )
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 4)
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
            isSelected: true,
            onClose: {},
            onTap: {}
        )
        .padding()
    }
}
