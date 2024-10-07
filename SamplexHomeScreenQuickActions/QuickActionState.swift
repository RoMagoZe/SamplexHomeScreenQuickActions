//
//  QuickActionState.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/10/08.
//

import SwiftUI

class QuickActionState: ObservableObject {

    static let shared = QuickActionState()
    private init() {}

    // 選択されたクイックアクションをパブリッシュする為の変数
    @Published var selectedAction: QuickAction?
    @Published var selectedActions: [QuickAction] = []
    // クイックアクションからアプリを開いたかどうかでUIを変更する為のフラグ
    private var isEnteredFromQuickAction = false

    // 定義したクイックアクションをUIApplication.shared.shortcutItemsに渡す関数
    func setActions() {
        let shortcutItems = selectedActions.map { $0.shortcutItem }
        UIApplication.shared.shortcutItems = shortcutItems
    }

    func toggleAction(_ action: QuickAction) {
        if let index = selectedActions.firstIndex(of: action) {
            selectedActions.remove(at: index)
        } else {
            selectedActions.append(action)
        }
        setActions()
    }
    // クイックアクションが選択された場合にそのクイックアクションに紐づくUIApplicationShortcutItemが渡ってくる
    // そのUIApplicationShortcutItemからQuickActionを生成して、selectedActionに渡す
    // またQuickActionがnilでは無いということは、クイックアクションからアプリを開いたということなので、
    // isEnteredFromQuickActionのフラグを切り替える
    func selectAction(by shortcutItem: UIApplicationShortcutItem?) {
        if let shortcutItem = shortcutItem {
                print("Shortcut item type: \(shortcutItem.type)")
            }

        let action = QuickAction(shortcutItem: shortcutItem)
        selectedAction = action
        isEnteredFromQuickAction = action == nil ? false : true
    }

    // クイックアクションからのアプリの立ち上げでは無い場合は、選択されたクイックアクションは無い為、selectedActionをnil
    func removeSelectedActionIfNeeded() {
        if isEnteredFromQuickAction {
            isEnteredFromQuickAction = false
            return
        }
        selectedAction = nil
    }
}
