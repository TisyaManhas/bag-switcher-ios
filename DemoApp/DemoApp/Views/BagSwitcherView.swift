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
    @State private var creatingNewBag = false
    @State private var newBagToAnimate: Bag?

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
                    LazyVGrid(columns: columns, spacing: 14) {
                        ForEach(Array(bagManager.bags.enumerated()), id: \.element.id) { index, bag in
                            if selectedBagForZoom == bag.id {
                                // Invisible placeholder to maintain grid spacing
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: 185, height: 290)
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
                    // Add new bag button - floating OR mini bag preview when creating
                    ZStack {
                        if let newBag = newBagToAnimate, creatingNewBag {
                            // Mini bag preview that will expand
                            BagScreenView(
                                bag: newBag,
                                bagIndex: bagManager.bags.count - 1,
                                totalBags: bagManager.bags.count
                            )
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .scaleEffect(0.05)
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                            .matchedGeometryEffect(
                                id: newBag.id,
                                in: namespace
                            )
                        } else {
                            Button(action: {
                                let newBag = bagManager.addNewBag()
                                newBagToAnimate = newBag
                                creatingNewBag = true

                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    withAnimation(.easeOut(duration: 0.4)) {
                                        selectedBagForZoom = newBag.id
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        onDismiss()
                                    }
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
                            }
                        }
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
        .onAppear {
            // Reset when switcher appears
            if selectedBagForZoom == nil {
                creatingNewBag = false
                newBagToAnimate = nil
            }
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Text("Saved Bags")
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
