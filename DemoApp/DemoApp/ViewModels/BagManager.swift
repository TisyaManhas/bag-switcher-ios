//
//  BagManager.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

@Observable
class BagManager {
    var bags: [Bag]
    var currentBagIndex: Int

    var currentBag: Bag {
        bags[currentBagIndex]
    }

    init() {
        self.bags = Bag.sampleBags
        self.currentBagIndex = 0
    }

    func addNewBag() -> Bag {
        let newBag = Bag(
            name: "New Bag \(bags.count + 1)",
            itemCount: 0,
            totalAmount: 0.0,
            color: [Color.blue, .green, .orange, .purple, .pink].randomElement() ?? .blue,
            icon: "bag.fill",
            createdDate: Date(),
            items: []
        )
        bags.append(newBag)
        currentBagIndex = bags.count - 1
        return newBag
    }

    func selectBag(at index: Int) {
        guard index >= 0 && index < bags.count else { return }
        currentBagIndex = index
    }

    func deleteBag(at index: Int) {
        guard bags.count > 1 else { return } // Keep at least one bag
        bags.remove(at: index)
        if currentBagIndex >= bags.count {
            currentBagIndex = bags.count - 1
        }
    }
}
