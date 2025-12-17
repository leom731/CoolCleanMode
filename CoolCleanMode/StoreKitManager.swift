//
//  StoreKitManager.swift
//  CoolCleanMode
//
//  Manages in-app purchases for tip jar using StoreKit 2
//

import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    // Published properties for UI updates
    @Published var products: [Product] = []
    @Published var purchaseState: PurchaseState = .idle
    @Published var errorMessage: String?

    // Product identifiers
    private let productIdentifiers: Set<String> = [
        "com.coolclean.tip.small",
        "com.coolclean.tip.medium",
        "com.coolclean.tip.large"
    ]

    // Transaction listener
    private var updateListenerTask: Task<Void, Error>?

    // Purchase states
    enum PurchaseState {
        case idle
        case loading
        case purchasing
        case purchased
        case failed(Error)
        case cancelled
    }

    init() {
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()

        // Load products on initialization
        Task {
            await loadProducts()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }

    // MARK: - Load Products

    /// Loads available products from the App Store
    func loadProducts() async {
        purchaseState = .loading

        do {
            // Request products from App Store
            let storeProducts = try await Product.products(for: productIdentifiers)

            // Sort products by price (lowest to highest)
            self.products = storeProducts.sorted { $0.price < $1.price }

            purchaseState = .idle
            print("✅ Loaded \(products.count) products")
        } catch {
            purchaseState = .failed(error)
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            print("❌ Failed to load products: \(error)")
        }
    }

    // MARK: - Purchase Product

    /// Purchases a product
    func purchase(_ product: Product) async {
        purchaseState = .purchasing

        do {
            // Attempt purchase
            let result = try await product.purchase()

            // Handle purchase result
            switch result {
            case .success(let verification):
                // Verify the transaction
                let transaction = try checkVerified(verification)

                // Deliver content to the user
                await deliverPurchase(transaction: transaction)

                // Mark transaction as finished
                await transaction.finish()

                purchaseState = .purchased
                print("✅ Purchase successful: \(product.displayName)")

            case .userCancelled:
                purchaseState = .cancelled
                print("ℹ️ User cancelled purchase")

            case .pending:
                purchaseState = .idle
                errorMessage = "Purchase is pending approval"
                print("⏳ Purchase pending approval")

            @unknown default:
                purchaseState = .idle
                print("⚠️ Unknown purchase result")
            }

        } catch {
            purchaseState = .failed(error)
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            print("❌ Purchase failed: \(error)")
        }
    }

    // MARK: - Transaction Verification

    /// Verifies a transaction to ensure it's legitimate
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, let error):
            // Transaction failed verification
            throw error
        case .verified(let safe):
            // Transaction is verified
            return safe
        }
    }

    // MARK: - Deliver Purchase

    /// Delivers the purchased content to the user
    private func deliverPurchase(transaction: Transaction) async {
        // For consumable products (tips), we just need to acknowledge the purchase
        // No need to persist anything since it's a one-time tip
        print("✅ Delivered purchase: \(transaction.productID)")
    }

    // MARK: - Transaction Listener

    /// Listens for transaction updates from the App Store
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through transaction updates
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    // Deliver the purchase
                    await self.deliverPurchase(transaction: transaction)

                    // Finish the transaction
                    await transaction.finish()
                } catch {
                    print("❌ Transaction verification failed: \(error)")
                }
            }
        }
    }

    // MARK: - Helper Methods

    /// Resets the purchase state
    func resetPurchaseState() {
        purchaseState = .idle
        errorMessage = nil
    }

    /// Gets a product by its identifier
    func product(for identifier: String) -> Product? {
        products.first { $0.id == identifier }
    }

    /// Checks if products are loaded
    var hasLoadedProducts: Bool {
        !products.isEmpty
    }
}

// MARK: - Product Extensions

extension Product {
    /// Returns a user-friendly display price
    var displayPrice: String {
        return displayPrice
    }
}
