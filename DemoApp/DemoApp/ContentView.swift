//
//  ContentView.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var bagManager = BagManager()
    @State private var showBagSwitcher = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Main content area
                VStack(spacing: 20) {
                    // Current bag display
                    currentBagView

                    // Sample content
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(bagManager.currentBag.items) { item in
                                itemRow(item)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }

                // Floating bag switcher button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        BagSwitcherButton(bagCount: bagManager.bags.count) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showBagSwitcher = true
                            }
                        }
                        .padding(.trailing, 24)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationTitle("EasyPay")
            .fullScreenCover(isPresented: $showBagSwitcher) {
                BagSwitcherView(bagManager: bagManager)
                    .transition(.move(edge: .bottom))
            }
        }
    }

    // MARK: - Current Bag View
    private var currentBagView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: bagManager.currentBag.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(bagManager.currentBag.color.gradient)

                VStack(alignment: .leading, spacing: 4) {
                    Text(bagManager.currentBag.name)
                        .font(.system(size: 22, weight: .bold))

                    HStack(spacing: 12) {
                        Label("\(bagManager.currentBag.itemCount) items", systemImage: "bag")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text("$\(String(format: "%.2f", bagManager.currentBag.totalAmount))")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }

                Spacer()

                // Bag indicator
                Text("\(bagManager.currentBagIndex + 1)/\(bagManager.bags.count)")
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
    ContentView()
}
