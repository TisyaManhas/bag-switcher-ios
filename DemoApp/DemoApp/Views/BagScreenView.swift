//
//  BagScreenView.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

/// Reusable view that shows the actual bag screen
/// Used both in main view (full size) and in cards (scaled down)
struct BagScreenView: View {
    let bag: Bag
    let bagIndex: Int
    let totalBags: Int

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Current bag display
                    currentBagView

                    // Sample content
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(bag.items) { item in
                                itemRow(item)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
            }
            .navigationTitle("EasyPay")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Current Bag View
    private var currentBagView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: bag.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(bag.color.gradient)

                VStack(alignment: .leading, spacing: 4) {
                    Text(bag.name)
                        .font(.system(size: 22, weight: .bold))

                    HStack(spacing: 12) {
                        Label("\(bag.itemCount) items", systemImage: "bag")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text("$\(String(format: "%.2f", bag.totalAmount))")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }

                Spacer()

                // Bag indicator
                Text("\(bagIndex + 1)/\(totalBags)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                    )
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal)
        }
    }

    // MARK: - Item Row
    private func itemRow(_ item: BagItem) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 16, weight: .medium))

                Text("Qty: \(item.quantity)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("$\(String(format: "%.2f", item.price * Double(item.quantity)))")
                .font(.system(size: 16, weight: .semibold))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    BagScreenView(
        bag: Bag.sampleBags[0],
        bagIndex: 0,
        totalBags: 4
    )
}
