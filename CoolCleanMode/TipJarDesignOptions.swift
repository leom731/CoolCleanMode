//
//  TipJarDesignOptions.swift
//  CoolCleanMode
//
//  Different design mockups for tip jar feature
//

import SwiftUI

struct TipJarDesignOptions: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                Text("Tip Jar Design Options")
                    .font(.title.bold())
                    .padding(.top)

                Divider()

                // Option 1: Minimal Text Link
                DesignOptionCard(title: "Option 1: Minimal Text Link", description: "Most subtle - just a small text link") {
                    TipJarOption1()
                }

                // Option 2: Subtle Button with Icon
                DesignOptionCard(title: "Option 2: Subtle Button with Icon", description: "Balanced - small button, muted colors") {
                    TipJarOption2()
                }

                // Option 3: Very Minimal Footer
                DesignOptionCard(title: "Option 3: Very Minimal Footer", description: "Ultra-subtle - blends with version number") {
                    TipJarOption3()
                }

                // Option 4: Friendly Card Style
                DesignOptionCard(title: "Option 4: Friendly Card Style", description: "Slightly more visible but still respectful") {
                    TipJarOption4()
                }

                // Option 5: Icon Row
                DesignOptionCard(title: "Option 5: Icon Row Style", description: "Clean horizontal layout") {
                    TipJarOption5()
                }
            }
            .padding()
        }
        .frame(width: 800, height: 900)
    }
}

// MARK: - Option 1: Minimal Text Link
struct TipJarOption1: View {
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {}) {
                Text("Buy me a coffee?")
                    .font(.system(size: 12))
                    .foregroundColor(.blue.opacity(0.7))
                    .underline()
            }
            .buttonStyle(.plain)

            Text("Tips are greatly appreciated but never necessary")
                .font(.system(size: 10))
                .foregroundColor(.secondary.opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
}

// MARK: - Option 2: Subtle Button with Icon
struct TipJarOption2: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Enjoying CoolClean?")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)

            Button(action: {}) {
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

            Text("Tips are appreciated but never required")
                .font(.system(size: 10))
                .foregroundColor(.secondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
}

// MARK: - Option 3: Very Minimal Footer
struct TipJarOption3: View {
    var body: some View {
        HStack(spacing: 15) {
            Text("v1.0")
                .font(.system(size: 12))
                .foregroundColor(.secondary)

            Text("•")
                .foregroundColor(.secondary.opacity(0.5))

            Button(action: {}) {
                HStack(spacing: 4) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 10))
                    Text("Tip")
                }
                .font(.system(size: 11))
                .foregroundColor(.secondary.opacity(0.7))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Option 4: Friendly Card Style
struct TipJarOption4: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.pink.opacity(0.6))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Support CoolClean")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                    Text("Tips help keep this app free and ad-free")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {}) {
                    Text("Tip")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.7))
                        .cornerRadius(6)
                }
                .buttonStyle(.plain)
            }
            .padding(12)
            .background(Color.secondary.opacity(0.08))
            .cornerRadius(10)

            Text("Completely optional")
                .font(.system(size: 10))
                .foregroundColor(.secondary.opacity(0.6))
        }
        .padding(.top, 20)
    }
}

// MARK: - Option 5: Icon Row Style
struct TipJarOption5: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.brown.opacity(0.6))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Enjoying the app?")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                    Text("Leave a tip if you'd like")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.secondary.opacity(0.5))
                }
                .buttonStyle(.plain)
            }

            Text("Tips are appreciated but completely optional")
                .font(.system(size: 10))
                .foregroundColor(.secondary.opacity(0.6))
        }
        .padding(.top, 20)
    }
}

// MARK: - Helper View for Design Cards
struct DesignOptionCard<Content: View>: View {
    let title: String
    let description: String
    let content: Content

    init(title: String, description: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.description = description
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // Mock main button (for context)
            Button(action: {}) {
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
            .disabled(true)

            // The actual tip jar design
            content
                .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
    }
}

// MARK: - Preview
#Preview("All Design Options") {
    TipJarDesignOptions()
}

#Preview("Option 1 - Minimal Text Link") {
    VStack {
        Text("Start Cleaning Mode Button")
            .padding()
        TipJarOption1()
    }
    .frame(width: 400, height: 300)
}

#Preview("Option 2 - Subtle Button") {
    VStack {
        Text("Start Cleaning Mode Button")
            .padding()
        TipJarOption2()
    }
    .frame(width: 400, height: 300)
}

#Preview("Option 3 - Footer Style") {
    VStack {
        Spacer()
        TipJarOption3()
    }
    .frame(width: 400, height: 300)
}

#Preview("Option 4 - Card Style") {
    VStack {
        Text("Start Cleaning Mode Button")
            .padding()
        TipJarOption4()
    }
    .frame(width: 400, height: 300)
}

#Preview("Option 5 - Icon Row") {
    VStack {
        Text("Start Cleaning Mode Button")
            .padding()
        TipJarOption5()
    }
    .frame(width: 400, height: 300)
}
