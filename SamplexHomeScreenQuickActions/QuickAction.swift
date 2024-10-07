//
//  QuickAction.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/10/08.
//

import SwiftUI

enum QuickAction: String, CaseIterable {
    case one = "one"
    case two = "two"
    case three = "three"
    case four = "four"
    case five = "five"


    // クイックアクションからアプリを開いた際にUIApplicationShortcutItemを取得
    // UIApplicationShortcutItem.type をしようして選択されたアクションの初期化
    init?(shortcutItem: UIApplicationShortcutItem?) {
        guard let shortcutItem = shortcutItem, let action = QuickAction(rawValue: shortcutItem.type) else { return nil }

        self = action
    }

    // UIApplicationShortcutItemの画像として使用するSystem Imageの名前
    var imageName: String {
        switch self {
        case .one:
            return "star"
        case .two:
            return "bell"
        case .three:
            return "book"
        case .four:
            return "paperplane"
        case .five:
            return "pencil"
        }
    }

    // 各ケースに該当するUIApplicationShortcutItemを返す
    // UIApplicationShortcutItemを初期化することで変更可能な動的クイックアクションを作成可能
    /**
     * type - 実行するクイックアクションの種類を識別するために使用する文字列
     * localizedTitle - ユーザーに表示されるタイトル
     * localizedSubTitle - ユーザーに表示されるサブタイトル
     * icon - クイックアクションのアイコン
     * userInfo - クイックアクション実行時に提供できるユーザー情報
     */
    var shortcutItem: UIApplicationShortcutItem {
        switch self {
        case .one:
            UIMutableApplicationShortcutItem(
                type: self.rawValue,
                localizedTitle: self.rawValue,
                localizedSubtitle: "oneです",
                icon: UIApplicationShortcutIcon(systemImageName: self.imageName)
            )

        case .two:
            UIMutableApplicationShortcutItem(
                type: self.rawValue,
                localizedTitle: self.rawValue,
                localizedSubtitle: "twoです",
                icon: UIApplicationShortcutIcon(systemImageName: self.imageName)
            )

        case .three:
            UIMutableApplicationShortcutItem(
                type: self.rawValue,
                localizedTitle: self.rawValue,
                localizedSubtitle: "threeです",
                icon: UIApplicationShortcutIcon(systemImageName: self.imageName)
            )

        case .four:
            UIMutableApplicationShortcutItem(
                type: self.rawValue,
                localizedTitle: self.rawValue,
                localizedSubtitle: "fourです",
                icon: UIApplicationShortcutIcon(systemImageName: self.imageName)
            )

        case .five:
            UIMutableApplicationShortcutItem(
                type: self.rawValue,
                localizedTitle: self.rawValue,
                localizedSubtitle: "fiveです",
                icon: UIApplicationShortcutIcon(systemImageName: self.imageName)
            )
        }
    }
}
