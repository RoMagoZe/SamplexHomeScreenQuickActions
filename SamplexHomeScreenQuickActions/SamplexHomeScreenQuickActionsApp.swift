//
//  SamplexHomeScreenQuickActionsApp.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/09/29.
//

import SwiftUI

@main
struct SamplexHomeScreenQuickActionsApp: App {
    
    @Environment(\.scenePhase) var scenePhase

    private let quickActionState = QuickActionState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(quickActionState)
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .active:
                quickActionState.removeSelectedActionIfNeeded()
            case .background:
                quickActionState.setActions()
            case .inactive:
                break
            @unknown default:
                fatalError()
            }
        }
    }
}
