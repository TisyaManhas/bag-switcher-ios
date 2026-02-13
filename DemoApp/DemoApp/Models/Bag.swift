//
//  Bag.swift
//  DemoApp
//
//  Created by Tisya Manhas on 13/02/26.
//

import SwiftUI

struct Bag: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var itemCount: Int
    var totalAmount: Double
    var color: Color
    var icon: String
    var createdDate: Date

    // Sample bag preview data
    var items: [BagItem]

    static func == (lhs: Bag, rhs: Bag) -> Bool {
        lhs.id == rhs.id
    }
}

struct BagItem: Identifiable {
    let id = UUID()
    var name: String
    var price: Double
    var quantity: Int
}

// Sample data for testing
extension Bag {
    static let sampleBags: [Bag] = [
        Bag(
            name: "Grocery Shopping",
            itemCount: 5,
            totalAmount: 45.99,
            color: .blue,
            icon: "cart.fill",
            createdDate: Date(),
            items: [
                BagItem(name: "Milk", price: 3.99, quantity: 2),
                BagItem(name: "Bread", price: 2.50, quantity: 1),
                BagItem(name: "Eggs", price: 4.99, quantity: 1)
            ]
        ),
        Bag(
            name: "Electronics",
            itemCount: 3,
            totalAmount: 299.99,
            color: .purple,
            icon: "laptopcomputer",
            createdDate: Date().addingTimeInterval(-3600),
            items: [
                BagItem(name: "USB Cable", price: 12.99, quantity: 2),
                BagItem(name: "Mouse Pad", price: 15.99, quantity: 1)
            ]
        ),
        Bag(
            name: "Home Decor",
            itemCount: 7,
            totalAmount: 156.50,
            color: .orange,
            icon: "house.fill",
            createdDate: Date().addingTimeInterval(-7200),
            items: [
                BagItem(name: "Candles", price: 8.99, quantity: 3),
                BagItem(name: "Picture Frame", price: 24.99, quantity: 2)
            ]
        ),
        Bag(
            name: "Fashion",
            itemCount: 4,
            totalAmount: 189.00,
            color: .pink,
            icon: "bag.fill",
            createdDate: Date().addingTimeInterval(-10800),
            items: [
                BagItem(name: "T-Shirt", price: 29.99, quantity: 2),
                BagItem(name: "Jeans", price: 59.99, quantity: 1)
            ]
        )
    ]
}
