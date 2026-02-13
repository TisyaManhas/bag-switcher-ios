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
        ZStack {
            // Main bag screen view
            BagScreenView(
                bag: bagManager.currentBag,
                bagIndex: bagManager.currentBagIndex,
                totalBags: bagManager.bags.count
            )

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
        .fullScreenCover(isPresented: $showBagSwitcher) {
            BagSwitcherView(bagManager: bagManager)
                .transition(.move(edge: .bottom))
        }
    }
}

#Preview {
    ContentView()
}
