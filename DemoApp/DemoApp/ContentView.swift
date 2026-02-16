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
    @State private var selectedBagForZoom: UUID?
    @Namespace private var animation

    var body: some View {
        ZStack {
            // Main bag screen view - hide when switcher is open and not zooming
            if !showBagSwitcher || selectedBagForZoom != nil {
                ZStack {
                    BagScreenView(
                        bag: bagManager.currentBag,
                        bagIndex: bagManager.currentBagIndex,
                        totalBags: bagManager.bags.count
                    )
                }
                .matchedGeometryEffect(
                    id: bagManager.currentBag.id,
                    in: animation
                )
                .zIndex(selectedBagForZoom != nil ? 10 : 0)
            }

            // Floating bag switcher button
            if !showBagSwitcher {
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

            // Bag switcher overlay
            if showBagSwitcher {
                BagSwitcherView(
                    bagManager: bagManager,
                    namespace: animation,
                    selectedBagForZoom: $selectedBagForZoom,
                    onDismiss: {
                        withAnimation(.easeOut(duration: 0.4)) {
                            showBagSwitcher = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            selectedBagForZoom = nil
                        }
                    }
                )
                .zIndex(5)
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
