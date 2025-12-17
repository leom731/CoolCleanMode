//
//  TipJarView.swift
//  CoolCleanMode
//
//  Tip jar interface for supporting the app
//

import SwiftUI

struct TipJarView: View {
    @Binding var isPresented: Bool
    @State private var selectedAmount: TipAmount?

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

            // Tip Amount Options
            VStack(spacing: 12) {
                Text("Choose a tip amount")
                    .font(.headline)
                    .foregroundColor(.secondary)

                HStack(spacing: 16) {
                    TipButton(amount: .small, selectedAmount: $selectedAmount)
                    TipButton(amount: .medium, selectedAmount: $selectedAmount)
                    TipButton(amount: .large, selectedAmount: $selectedAmount)
                }
                .padding(.horizontal)
            }

            // Purchase Button
            if selectedAmount != nil {
                Button(action: {
                    // TODO: Implement StoreKit purchase
                    // For now, just show a thank you message
                    isPresented = false
                }) {
                    HStack {
                        Image(systemName: "heart.fill")
                        Text("Send Tip")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .buttonStyle(.plain)
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

    var isSelected: Bool {
        selectedAmount == amount
    }

    var body: some View {
        Button(action: {
            selectedAmount = amount
        }) {
            VStack(spacing: 8) {
                Text(amount.displayName)
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
    }
}

// MARK: - Preview
#Preview {
    TipJarView(isPresented: .constant(true))
}
