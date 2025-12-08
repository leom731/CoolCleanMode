//
//  InputBlocker.swift
//  CoolCleanMode
//
//  Handles blocking keyboard and trackpad input
//

import Foundation
import Cocoa
import Carbon
import ApplicationServices

class InputBlocker: ObservableObject {
    @Published var isCleaningModeActive = false

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    // Key combo: Ctrl+Opt+Cmd+K
    private let exitModifierFlags: CGEventFlags = [.maskControl, .maskAlternate, .maskCommand]
    private let exitKeyCode: CGKeyCode = 40 // K key
    private let accessibilityPromptOptions: CFDictionary = [
        kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true
    ] as CFDictionary

    func openSystemPreferences() {
        // Open Privacy & Security settings
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") {
            NSWorkspace.shared.open(url)
        }
    }

    func startCleaningMode() {
        guard !isCleaningModeActive else { return }

        // Trigger a single, system-managed accessibility prompt if permission is missing
        guard AXIsProcessTrustedWithOptions(accessibilityPromptOptions) else {
            print("❌ Accessibility permission required - prompting user via System Settings")
            return
        }

        // Try to create event tap - this is the definitive test for permissions
        let eventMask = (1 << CGEventType.keyDown.rawValue) |
                       (1 << CGEventType.keyUp.rawValue) |
                       (1 << CGEventType.flagsChanged.rawValue) |
                       (1 << CGEventType.scrollWheel.rawValue) |
                       (1 << CGEventType.leftMouseDown.rawValue) |
                       (1 << CGEventType.leftMouseUp.rawValue) |
                       (1 << CGEventType.rightMouseDown.rawValue) |
                       (1 << CGEventType.rightMouseUp.rawValue) |
                       (1 << CGEventType.leftMouseDragged.rawValue) |
                       (1 << CGEventType.rightMouseDragged.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else { return Unmanaged.passUnretained(event) }
                let blocker = Unmanaged<InputBlocker>.fromOpaque(refcon).takeUnretainedValue()
                return blocker.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            // Event tap creation failed - permissions not granted
            print("❌ Failed to create event tap - please grant accessibility permissions")
            return
        }

        // Success! Event tap created
        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)

        isCleaningModeActive = true
        print("✅ Cleaning mode activated - keyboard, trackpad, and mouse clicks are now blocked")
    }

    func stopCleaningMode() {
        guard isCleaningModeActive else { return }

        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }

        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
        }

        eventTap = nil
        runLoopSource = nil
        isCleaningModeActive = false
        print("✅ Cleaning mode deactivated - all input restored")
    }

    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        // Handle keyboard events
        if type == .keyDown || type == .keyUp {
            // Check for exit key combo (Ctrl+Opt+Cmd+K)
            let flags = event.flags
            let keyCode = event.getIntegerValueField(.keyboardEventKeycode)

            if type == .keyDown &&
               flags.contains(.maskControl) &&
               flags.contains(.maskAlternate) &&
               flags.contains(.maskCommand) &&
               keyCode == Int64(exitKeyCode) {
                // Exit combo detected
                DispatchQueue.main.async {
                    self.stopCleaningMode()
                }
                return nil // Block this event
            }

            // Block all other keyboard events
            return nil
        }

        // Handle modifier flags changes
        if type == .flagsChanged {
            // Block flag changes to prevent modifier keys from doing anything
            return nil
        }

        // Block scroll wheel events (trackpad scrolling)
        if type == .scrollWheel {
            return nil
        }

        // Block ALL mouse and trackpad clicks
        // Only way to exit is via keyboard combo: Ctrl+Opt+Cmd+K
        if type == .leftMouseDown || type == .leftMouseUp ||
           type == .rightMouseDown || type == .rightMouseUp ||
           type == .leftMouseDragged || type == .rightMouseDragged {
            return nil // Block all clicks
        }

        // Allow cursor movement (so you can see the mouse is still working)
        // but all clicking is disabled
        return Unmanaged.passUnretained(event)
    }

    deinit {
        stopCleaningMode()
    }
}
