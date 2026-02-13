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
                        bagSwitcherButton
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

    // MARK: - Bag Switcher Button
    private var bagSwitcherButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                showBagSwitcher = true
            }
        }) {
            ZStack {
                // Stacked cards effect (similar to Safari tabs icon)
                ForEach(0..<min(3, bagManager.bags.count), id: \.self) { index in
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

                    Text("\(bagManager.bags.count)")
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
    ContentView()
}
