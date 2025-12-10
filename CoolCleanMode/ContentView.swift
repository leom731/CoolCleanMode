//
//  ContentView.swift
//  CoolCleanMode
//
//  Main user interface for CoolClean Mode
//

import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject private var inputBlocker = InputBlocker()
    @State private var activationError: InputBlockerActivationError?
    @State private var showAccessibilityHelp = false

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

#Preview {
    ContentView()
}
