//
//  TipJarView.swift
//  CoolCleanMode
//
//  Tip jar interface for supporting the app
//

import SwiftUI
import StoreKit

struct TipJarView: View {
    @Binding var isPresented: Bool
    @StateObject private var storeKitManager = StoreKitManager()
    @State private var selectedAmount: TipAmount?
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
            .padding(.top, 36)

            Divider()
                .padding(.horizontal)

            // Tip Amount Options
            VStack(spacing: 12) {
                Text("Choose a tip amount")
                    .font(.headline)
                    .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    TipButton(
                        amount: .small,
                        selectedAmount: $selectedAmount,
                        product: storeKitManager.products.first { $0.id == TipAmount.small.productID }
                    )
                    TipButton(
                        amount: .medium,
                        selectedAmount: $selectedAmount,
                        product: storeKitManager.products.first { $0.id == TipAmount.medium.productID }
                    )
                    TipButton(
                        amount: .large,
                        selectedAmount: $selectedAmount,
                        product: storeKitManager.products.first { $0.id == TipAmount.large.productID }
                    )
                }
                .padding(.horizontal)
            }

            // Purchase Button
            if let selectedAmount {
                Button(action: {
                    Task {
                        await purchaseSelectedTip()
                    }
                }) {
                    HStack {
                        if case .purchasing = storeKitManager.purchaseState {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Image(systemName: "heart.fill")
                        }

                        Text(buttonText)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(buttonColor)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
                .disabled(isPurchasing)
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
        .animation(.spring(response: 0.3), value: selectedAmount)
        .alert("Thank You!", isPresented: $showThankYou) {
            Button("You're Welcome!") {
                isPresented = false
            }
        } message: {
            Text("Your support means the world! Thank you for helping keep CoolClean free and awesome.")
        }
        .alert("Purchase Error", isPresented: .constant(storeKitManager.errorMessage != nil)) {
            Button("OK") {
                storeKitManager.resetPurchaseState()
            }
        } message: {
            if let errorMessage = storeKitManager.errorMessage {
                Text(errorMessage)
            }
        }
        .onChange(of: storeKitManager.purchaseState) { _, newState in
            if case .purchased = newState {
                showThankYou = true
                storeKitManager.resetPurchaseState()
            }
        }
    }

    // MARK: - Helper Methods

    private func purchaseSelectedTip() async {
        guard let selectedAmount,
              let product = storeKitManager.products.first(where: { $0.id == selectedAmount.productID }) else {
            return
        }

        await storeKitManager.purchase(product)
    }

    // MARK: - Computed Properties

    private var isPurchasing: Bool {
        if case .purchasing = storeKitManager.purchaseState {
            return true
        }
        return false
    }

    private var buttonText: String {
        if case .purchasing = storeKitManager.purchaseState {
            return "Processing..."
        }

        if let selectedAmount,
           let product = storeKitManager.products.first(where: { $0.id == selectedAmount.productID }) {
            return "Send \(product.displayPrice) Tip"
        }

        return "Send Tip"
    }

    private var buttonColor: Color {
        if case .purchasing = storeKitManager.purchaseState {
            return Color.blue.opacity(0.6)
        }
        return Color.blue
    }
}

// MARK: - Tip Amount Enum
enum TipAmount: String, CaseIterable {
    case small = "$1"
    case medium = "$3"
    case large = "$5"

    var displayName: String {
        rawValue
    }

    var description: String {
        switch self {
        case .small: return "Coffee"
        case .medium: return "Generous"
        case .large: return "Amazing!"
        }
    }

    // TODO: Add actual product IDs from App Store Connect
    var productID: String {
        switch self {
        case .small: return "com.coolclean.tip.small"
        case .medium: return "com.coolclean.tip.medium"
        case .large: return "com.coolclean.tip.large"
        }
    }
}

// MARK: - Tip Button Component
struct TipButton: View {
    let amount: TipAmount
    @Binding var selectedAmount: TipAmount?
    let product: Product?

    var isSelected: Bool {
        selectedAmount == amount
    }

    var displayPrice: String {
        product?.displayPrice ?? amount.displayName
    }

    var body: some View {
        Button(action: {
            selectedAmount = amount
        }) {
            VStack(spacing: 8) {
                Text(displayPrice)
                    .font(.title2.bold())
                    .foregroundColor(isSelected ? .white : .primary)

                Text(amount.description)
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
        }
        .buttonStyle(.plain)
        .disabled(product == nil)
        .opacity(product == nil ? 0.5 : 1.0)
    }
}

// MARK: - Preview
#Preview {
    TipJarView(isPresented: .constant(true))
}
