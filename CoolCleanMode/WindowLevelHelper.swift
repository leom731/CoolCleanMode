//
//  WindowLevelHelper.swift
//  CoolCleanMode
//
//  Provides a SwiftUI modifier to keep the window floating above others.
//

import SwiftUI
import AppKit

struct WindowLevelSetter: NSViewRepresentable {
    let level: NSWindow.Level

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            view.window?.level = level
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        DispatchQueue.main.async {
            nsView.window?.level = level
        }
    }
}

extension View {
    func windowLevel(_ level: NSWindow.Level = NSWindow.Level.floating) -> some View {
        background(WindowLevelSetter(level: level))
    }
}
