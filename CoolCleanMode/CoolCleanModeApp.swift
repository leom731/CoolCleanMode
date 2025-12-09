//
//  CoolCleanModeApp.swift
//  CoolCleanMode
//
//  Created on 2025-12-05.
//

import SwiftUI
import AppKit

@main
struct CoolCleanModeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .windowLevel(NSWindow.Level.floating)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}
