//
//  SamplexHomeScreenQuickActionsApp.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/09/29.
//

import SwiftUI

@main
struct SamplexHomeScreenQuickActionsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // たぶんSwiftUIで不要
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


class AppDelegate: NSObject, UIApplicationDelegate {

    private let quickActionState = QuickActionState.shared

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        quickActionState.selectAction(by: options.shortcutItem)

        let configuration = UISceneConfiguration(
            name: connectingSceneSession.configuration.name,
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let quickActionState = QuickActionState.shared

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, options: UIScene.ConnectionOptions, completionHandler: @escaping (Bool) -> Void) {
        quickActionState.selectAction(by: options.shortcutItem)
        completionHandler(true)
    }
}
