//
//  BagSwitcherView.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

struct BagSwitcherView: View {
    @Bindable var bagManager: BagManager
    let namespace: Namespace.ID
    @Binding var selectedBagForZoom: UUID?
    let onDismiss: () -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var showingAddBagAnimation = false

    // Grid columns - 2 columns like Safari
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            // Background blur - more transparent like iOS 18+
            Color.black.opacity(0.15)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 0) {
                // Header
                headerView

                // Scrollable bag grid
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(bagManager.bags.enumerated()), id: \.element.id) { index, bag in
                            if selectedBagForZoom == bag.id {
                                // Invisible placeholder to maintain grid spacing
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 160, height: 280)
                            } else {
                                BagCardView(
                                    bag: bag,
                                    bagIndex: index,
                                    totalBags: bagManager.bags.count,
                                    isSelected: index == bagManager.currentBagIndex,
                                    namespace: namespace,
                                    onClose: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            bagManager.deleteBag(at: index)
                                        }
                                    },
                                    onTap: {
                                        withAnimation(.easeOut(duration: 0.4)) {
                                            selectedBagForZoom = bag.id
                                            bagManager.selectBag(at: index)
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                            onDismiss()
                                        }
                                    }
                                )
                                .transition(.scale.combined(with: .opacity))
                            }
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
                HStack(spacing: 20) {
                    // Add new bag button - floating
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
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
                            .scaleEffect(showingAddBagAnimation ? 1.2 : 1.0)
                    }

                    Spacer()

                    // Bag count - floating
                    Text("\(bagManager.bags.count) Bags")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)

                    Spacer()

                    // Done button - floating
                    Button(action: { onDismiss() }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(Color.blue.gradient)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
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
                        onDismiss()
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
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    @Previewable @State var selectedBag: UUID? = nil

    BagSwitcherView(
        bagManager: BagManager(),
        namespace: namespace,
        selectedBagForZoom: $selectedBag,
        onDismiss: {}
    )
}
