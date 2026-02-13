//
//  BagSwitcherView.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

struct BagSwitcherView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var bagManager: BagManager

    @State private var dragOffset: CGSize = .zero
    @State private var showingAddBagAnimation = false

    // Grid columns - 2 columns like Safari
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissView()
                }

            VStack(spacing: 0) {
                // Header
                headerView

                // Scrollable bag grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(bagManager.bags.enumerated()), id: \.element.id) { index, bag in
                            BagCardView(
                                bag: bag,
                                isSelected: index == bagManager.currentBagIndex,
                                onClose: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        bagManager.deleteBag(at: index)
                                    }
                                },
                                onTap: {
                                    bagManager.selectBag(at: index)
                                    dismissView()
                                }
                            )
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 100) // Space for bottom toolbar
                }

                Spacer()
            }

            // Bottom toolbar
            VStack {
                Spacer()
                bottomToolbar
            }
        }
        .offset(y: dragOffset.height)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    if value.translation.height > 150 {
                        dismissView()
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = .zero
                        }
                    }
                }
        )
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Text("All Bags")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)

            Spacer()

            Button(action: { dismissView() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.secondary)
                    .symbolRenderingMode(.hierarchical)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }

    // MARK: - Bottom Toolbar
    private var bottomToolbar: some View {
        HStack(spacing: 20) {
            // Add new bag button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    bagManager.addNewBag()
                    showingAddBagAnimation = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showingAddBagAnimation = false
                }
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
                    .scaleEffect(showingAddBagAnimation ? 1.2 : 1.0)
            }

            Spacer()

            // Bag count
            Text("\(bagManager.bags.count) Bags")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                )

            Spacer()

            // Done button
            Button(action: { dismissView() }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(Color.blue.gradient)
                    )
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 0)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }

    // MARK: - Helper Functions
    private func dismissView() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            dismiss()
        }
    }
}

#Preview {
    BagSwitcherView(bagManager: BagManager())
}
