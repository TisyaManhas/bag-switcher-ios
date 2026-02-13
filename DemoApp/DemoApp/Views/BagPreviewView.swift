//
//  BagPreviewView.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

/// This view shows exactly what the screen looks like for a specific bag
/// (like Safari shows webpage previews in tab cards)
struct BagPreviewView: View {
    let bag: Bag
    let bagIndex: Int
    let totalBags: Int

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Current bag display (matching ContentView)
                    currentBagView

                    // Sample content (matching ContentView)
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
                .padding(.top, 8)
            }
            .navigationTitle("EasyPay")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Current Bag View (matches ContentView)
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

    // MARK: - Item Row (matches ContentView)
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
    BagPreviewView(
        bag: Bag.sampleBags[0],
        bagIndex: 0,
        totalBags: 4
    )
}
