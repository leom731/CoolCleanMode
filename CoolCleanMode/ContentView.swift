//
//  ContentView.swift
//  CoolCleanMode
//
//  Main user interface for CoolClean Mode
//

import SwiftUI
import AppKit
import StoreKit

struct ContentView: View {
    @StateObject private var inputBlocker = InputBlocker()
    @State private var activationError: InputBlockerActivationError?
    @State private var showAccessibilityHelp = false
    @State private var showTipJar = false

    var body: some View {
        ZStack {
            // Background color changes based on mode
            (inputBlocker.isCleaningModeActive ? Color.green : Color.blue)
                .opacity(0.1)
                .ignoresSafeArea()

            VStack(spacing: 30) {
                // App Title
                Text("CoolClean Mode")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.primary)

                // Status Indicator
                VStack(spacing: 10) {
                    Circle()
                        .fill(inputBlocker.isCleaningModeActive ? Color.green : Color.gray)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .shadow(color: inputBlocker.isCleaningModeActive ? .green : .clear, radius: 10)

                    Text(inputBlocker.isCleaningModeActive ? "CLEANING MODE ACTIVE" : "Ready to Clean")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(inputBlocker.isCleaningModeActive ? .green : .secondary)
                }
                .padding(.bottom, 20)

                if !inputBlocker.isCleaningModeActive {
                    // Instructions when inactive
                    VStack(alignment: .leading, spacing: 15) {
                        InstructionRow(
                            icon: "keyboard",
                            text: "Keyboard will be disabled"
                        )
                        InstructionRow(
                            icon: "computermouse",
                            text: "Trackpad clicks will be disabled"
                        )
                        InstructionRow(
                            icon: "cursorarrow.click",
                            text: "Mouse clicks will be disabled"
                        )
                        InstructionRow(
                            icon: "command",
                            text: "Press ⌃⌥⌘K to re-enable"
                        )
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 30)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(15)

                    // Start button
                    Button(action: {
                        activationError = inputBlocker.startCleaningMode()
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Start Cleaning Mode")
                            Image(systemName: "sparkles")
                        }
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 10)

                    // Tip Jar Section
                    VStack(spacing: 8) {
                        Text("Enjoying CoolClean?")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)

                        Button(action: {
                            showTipJar = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(.system(size: 12))
                                Text("Leave a Tip")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)

                        Text("Tipping is greatly appreciated but not necessary")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)

                } else {
                    // Instructions when active
                    VStack(spacing: 25) {
                        Text("🧽 Clean your keyboard and trackpad safely! 🧽")
                            .font(.system(size: 20, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.primary)
                            .padding(.horizontal)

                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "keyboard.badge.ellipsis")
                                    .foregroundColor(.green)
                                Text("Keyboard: BLOCKED")
                                    .font(.system(size: 18, weight: .semibold))
                            }

                            HStack {
                                Image(systemName: "computermouse.fill")
                                    .foregroundColor(.green)
                                Text("Trackpad Clicks: BLOCKED")
                                    .font(.system(size: 18, weight: .semibold))
                            }

                            HStack {
                                Image(systemName: "cursorarrow.click")
                                    .foregroundColor(.green)
                                Text("Mouse Clicks: BLOCKED")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                        }
                        .padding(.vertical, 15)

                        Divider()
                            .padding(.horizontal, 40)

                        // Prominent keyboard shortcut display
                        VStack(spacing: 15) {
                            Text("To re-enable, press:")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.secondary)

                            VStack(spacing: 12) {
                                Text("⌃⌥⌘K")
                                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 20)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .shadow(color: .green.opacity(0.4), radius: 15, x: 0, y: 8)

                                Text("Control + Option + Command + K")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                }

                Spacer()

                // Footer
                Text("v1.0")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(40)
        }
        .frame(width: 600, height: 700)
        .windowLevel(inputBlocker.isCleaningModeActive ? .floating : .normal)
        .alert(item: $activationError) { error in
            switch error {
            case .accessibilityNotGranted:
                Alert(
                    title: Text("Enable Accessibility Access"),
                    message: Text("CoolClean Mode needs Accessibility and Input Monitoring permission so it can block keyboard, trackpad, and mouse clicks. Tap Open Settings, then click + to add CoolClean Mode and toggle it on."),
                    primaryButton: .default(Text("Open Settings")) {
                        inputBlocker.openSystemPreferences()
                        showAccessibilityHelp = true
                    },
                    secondaryButton: .cancel(Text("Not Now")) {
                        activationError = nil
                    }
                )
            case .eventTapCreationFailed:
                Alert(
                    title: Text("Unable to Start Cleaning Mode"),
                    message: Text("macOS blocked the input monitor. Please enable Accessibility permission, then quit and relaunch before trying again."),
                    dismissButton: .default(Text("OK")) {
                        activationError = nil
                    }
                )
            }
        }
        .sheet(isPresented: $showAccessibilityHelp) {
            VStack(spacing: 20) {
                Text("Add CoolClean Mode to Accessibility")
                    .font(.title2.bold())

                VStack(alignment: .leading, spacing: 12) {
                    Text("1. In System Settings → Privacy & Security → Accessibility, unlock to make changes.")
                    Text("2. Click the + button, choose CoolClean Mode.app, and click Open. (You can also drag the app from Finder into the list.)")
                    Text("3. Toggle CoolClean Mode on.")
                    Text("4. Return here and tap Start Cleaning Mode again.")
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Button("Show App in Finder") {
                    inputBlocker.revealAppInFinder()
                }
                .buttonStyle(.borderedProminent)

                Button("Done") {
                    showAccessibilityHelp = false
                    activationError = nil
                }
                .buttonStyle(.bordered)
            }
            .padding(24)
            .frame(minWidth: 420)
        }
        .sheet(isPresented: $showTipJar) {
            TipJarView(isPresented: $showTipJar)
        }
    }
}

struct InstructionRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 30)

            Text(text)
                .font(.system(size: 16))
                .foregroundColor(.primary)

            Spacer()
        }
    }
}

// MARK: - Tip Jar View
struct TipJarView: View {
    @Binding var isPresented: Bool
    @StateObject private var storeKit = StoreKitManager()
    @State private var selectedProduct: Product?
    @State private var showThankYou = false

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.brown.opacity(0.7))

                Text("Support CoolClean")
                    .font(.title2.bold())

                Text("Your tips help keep this app free, ad-free, and constantly improving")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 20)

            Divider()
                .padding(.horizontal)

            // Loading or Product Options
            if storeKit.hasLoadedProducts {
                VStack(spacing: 12) {
                    Text("Choose a tip amount")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 16) {
                        ForEach(storeKit.products, id: \.id) { product in
                            ProductTipButton(
                                product: product,
                                isSelected: selectedProduct?.id == product.id,
                                isDisabled: storeKit.purchaseState == .purchasing
                            ) {
                                selectedProduct = product
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                ProgressView("Loading tip options...")
                    .padding()
            }

            // Error Message
            if let errorMessage = storeKit.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Purchase Button
            if let product = selectedProduct {
                Button(action: {
                    Task {
                        await purchaseProduct(product)
                    }
                }) {
                    HStack {
                        if storeKit.purchaseState == .purchasing {
                            ProgressView()
                                .scaleEffect(0.8)
                                .frame(width: 20, height: 20)
                        } else {
                            Image(systemName: "heart.fill")
                        }
                        Text(storeKit.purchaseState == .purchasing ? "Processing..." : "Send \(product.displayPrice) Tip")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(storeKit.purchaseState == .purchasing ? Color.gray : Color.blue)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .disabled(storeKit.purchaseState == .purchasing)
                .padding(.horizontal)
                .transition(.scale.combined(with: .opacity))
            }

            Spacer()

            // Footer note
            VStack(spacing: 8) {
                Text("Tips are completely optional")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("CoolClean will always remain free with all features")
                    .font(.caption2)
                    .foregroundColor(.secondary.opacity(0.7))
            }
            .padding(.bottom, 20)

            // Close button
            Button("Maybe Later") {
                isPresented = false
            }
            .buttonStyle(.bordered)
            .padding(.bottom, 16)
        }
        .frame(width: 400, height: 500)
        .animation(.spring(response: 0.3), value: selectedProduct)
        .alert("Thank You! 💙", isPresented: $showThankYou) {
            Button("You're Welcome!") {
                isPresented = false
            }
        } message: {
            Text("Your support means the world! Your tip helps keep CoolClean free and constantly improving.")
        }
        .onChange(of: storeKit.purchaseState) { newState in
            if case .purchased = newState {
                showThankYou = true
                storeKit.resetPurchaseState()
            }
        }
    }

    private func purchaseProduct(_ product: Product) async {
        await storeKit.purchase(product)
    }
}

// MARK: - Product Tip Button Component
struct ProductTipButton: View {
    let product: Product
    let isSelected: Bool
    let isDisabled: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                Text(product.displayPrice)
                    .font(.title2.bold())
                    .foregroundColor(isSelected ? .white : .primary)

                Text(descriptionForProduct(product))
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.9) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.secondary.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .opacity(isDisabled ? 0.6 : 1.0)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    private func descriptionForProduct(_ product: Product) -> String {
        // Map product IDs to friendly descriptions
        if product.id.contains("small") {
            return "Coffee"
        } else if product.id.contains("medium") {
            return "Generous"
        } else if product.id.contains("large") {
            return "Amazing!"
        } else {
            return "Tip"
        }
    }
}

// MARK: - StoreKit Manager
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
    enum PurchaseState: Equatable {
        case idle
        case loading
        case purchasing
        case purchased
        case failed(Error)
        case cancelled

        static func == (lhs: PurchaseState, rhs: PurchaseState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle),
                 (.loading, .loading),
                 (.purchasing, .purchasing),
                 (.purchased, .purchased),
                 (.cancelled, .cancelled):
                return true
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
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
    nonisolated private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
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
    private func deliverPurchase(transaction: StoreKit.Transaction) async {
        // For consumable products (tips), we just need to acknowledge the purchase
        // No need to persist anything since it's a one-time tip
        print("✅ Delivered purchase: \(transaction.productID)")
    }

    // MARK: - Transaction Listener

    /// Listens for transaction updates from the App Store
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through transaction updates
            for await result in StoreKit.Transaction.updates {
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

#Preview {
    ContentView()
}
