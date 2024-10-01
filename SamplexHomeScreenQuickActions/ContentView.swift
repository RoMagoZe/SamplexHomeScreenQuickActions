//
//  ContentView.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/09/29.
//

import SwiftUI


enum QuickAction: String, CaseIterable {
    case one = "one"
    case two = "two"
    case three = "three"


    /// クイックアクションからアプリを開いた際にUIApplicationShortcutItemを取得
    /// UIApplicationShortcutItem.type をしようして選択されたアクションの初期化
    init?(shortcutItem: UIApplicationShortcutItem?) {
        guard let shortcutItem = shortcutItem, let action = QuickAction(rawValue: shortcutItem.type) else { return nil }

        self = action
    }

    /// UIApplicationShortcutItemの画像として使用するSystem Imageの名前
    var imageName: String {
        switch self {
        case .one:
            return "one"
        case .two:
            return "two"
        case .three:
            return "three"
        }
    }

    /// 各ケースに該当するUIApplicationShortcutItemを返す
    /// UIApplicationShortcutItemを初期化することで変更可能な動的クイックアクションを作成可能
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
        }
    }
}

class QuickActionState: ObservableObject {

    static let shared = QuickActionState()
    private init() {}

    // 選択されたクイックアクションをパブリッシュする為の変数
    @Published var selectedAction: QuickAction?
    // クイックアクションからアプリを開いたかどうかでUIを変更する為のフラグ
    private var isEnteredFromQuickAction = false

    // 定義したクイックアクションをUIApplication.shared.shortcutItemsに渡す関数
    func setActions() {
        let shortcutItems = QuickAction.allCases.map { $0.shortcutItem }
        UIApplication.shared.shortcutItems = shortcutItems
    }

    // クイックアクションが選択された場合にそのクイックアクションに紐づくUIApplicationShortcutItemが渡ってくる
    // そのUIApplicationShortcutItemからQuickActionを生成して、selectedActionに渡す
    // またQuickActionがnilでは無いということは、クイックアクションからアプリを開いたということなので、
    // isEnteredFromQuickActionのフラグを切り替える
    func selectAction(by shortcutItem: UIApplicationShortcutItem?) {
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

struct ContentView: View {

    // 選択されたクイックアクションの状態によってViewを変更する為、EnvironmentObjectを定義
    @EnvironmentObject var quickActionsState: QuickActionState

    // 選択されているクイックアクションによって動的に変更する背景色を用意
    private var backgroundColor: Color {
        switch quickActionsState.selectedAction {
        case .one:
                .red
        case .two:
                .blue
        case .three:
                .yellow
        case .none:
                .white
        }
    }

    // 背景色には上記で用意したbackgroundColorを使用
    // 表示するImageのシンボルにはQuickAction.imageNameを渡す
    // selectedActionがnilの場合にはImageは表示されない
    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)
                .ignoresSafeArea()

            if let action = quickActionsState.selectedAction {
                Image(systemName: action.imageName)
                    .resizable()
                    .frame(width: 150, height: 200)
                    .foregroundColor(action == .three ? .black : .white)
            }
        }
    }
}

#Preview {
    ContentView()
}
