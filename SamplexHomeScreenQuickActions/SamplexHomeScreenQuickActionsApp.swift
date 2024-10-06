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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let quickActionState = QuickActionState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(quickActionState)
            // onChangeはWindowGroupの中で呼び出す
                .onChange(of: scenePhase) { newValue in
                    switch newValue {
                    case .active:
                        quickActionState.removeSelectedActionIfNeeded()
                    case .background:
                        print("back ground")
                        quickActionState.setActions()
                    case .inactive:
                        break
                    default:
                        break
                    }
                }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {

    private let quickActionState = QuickActionState.shared

    // この関数は、Sceneが作成される時に、UIKitのための設定を行う
    // このメソッドは起動時に一度呼ばれます。
    // この第三引数optionsは選択されたクイックアクションに紐づくUIApplicationShortcutItemを持っている為、
    // そのshortcutItemをselectActionに渡して実行しています。
    // またSceneDelegateを呼ぶために、configuration.delegateClassに下記で説明するSceneDelegateを渡しています。
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        // ショートカットアイテムのタイプをデバッグ用にコンソールに出力
        print("嗚呼", options.shortcutItem?.type)
        // ショートカットアイテムに基づいてアクションを選択
        quickActionState.selectAction(by: options.shortcutItem)
        // 新しいシーンの設定を定義するために UISceneConfiguration を作成
        let configuration = UISceneConfiguration(
            // シーンの名前を取得
            name: connectingSceneSession.configuration.name,
            // セッションの役割を取得
            sessionRole: connectingSceneSession.role
        )
        // シーンのデリゲートクラスを設定 (SceneDelegate.self)
        configuration.delegateClass = SceneDelegate.self
        // 構成を返して、シーンの初期化に使用
        return configuration
    }
}


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let quickActionState = QuickActionState.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

            if let shortcutItem = connectionOptions.shortcutItem {
                quickActionState.selectAction(by: shortcutItem)
            }
            guard let _ = (scene as? UIWindowScene) else { return }
        }

    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print(shortcutItem.localizedTitle as Any)
        quickActionState.selectAction(by: shortcutItem) // クイックアクションの選択を反映
        completionHandler(true)
    }
}
