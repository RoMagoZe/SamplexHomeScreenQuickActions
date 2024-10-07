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
                .onChange(of: scenePhase) { newPhase in
                    switch newPhase {
                    // active: ユーザーがアクティブに操作している状態
                    case .active:
                        quickActionState.removeSelectedActionIfNeeded()
                    // background: アプリがバックグラウンドで動作している状態
                    case .background:
                        quickActionState.setActions()
                    // inactive: 一時的に操作されていない状態
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
    // このメソッドは起動時に一度呼ばれる
    // この第三引数optionsは選択されたクイックアクションに紐づくUIApplicationShortcutItemを持っている為、
    // そのshortcutItemをselectActionに渡して実行
    // またSceneDelegateを呼ぶために、configuration.delegateClassに下記で説明するSceneDelegateを渡す
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

    // メインウィンドウを保持するプロパティ
    // アプリのUIのルートコンテナとして、ビューやコントローラを管理するために使用
    var window: UIWindow?

    // クイックアクションの選択状態を保持するシングルトンインスタンス
    private let quickActionState = QuickActionState.shared

    // シーンがアプリに接続される直前に呼び出されるメソッド
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

            // 起動時にクイックアクションが選択されている場合、その情報を quickActionState に反映
            if let shortcutItem = connectionOptions.shortcutItem {
                quickActionState.selectAction(by: shortcutItem)
            }
            // シーンが UIWindowScene であることを確認
            guard let _ = (scene as? UIWindowScene) else { return }
        }

    // ホーム画面のクイックアクションが選択された時に呼び出されるメソッド
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // 選択されたクイックアクションのタイトルをコンソールに出力
        print(shortcutItem.localizedTitle as Any)
        // クイックアクションの選択を反映
        quickActionState.selectAction(by: shortcutItem)
        // クイックアクションの処理が完了したことを通知
        completionHandler(true)
    }
}
