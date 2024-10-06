//
//  ContentView.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/09/29.
//

import SwiftUI
import Foundation

enum QuickAction: String, CaseIterable {
    case one = "one"
    case two = "two"
    case three = "three"
    case four = "four"
    case five = "five"


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

struct ContentView: View {

    // 選択されたクイックアクションの状態によってViewを変更する為、EnvironmentObjectを定義
    @EnvironmentObject var quickActionsState: QuickActionState
    @State private var showConfiguration = false

    // 選択されているクイックアクションによって動的に変更する背景色を用意
    private var backgroundColor: Color {
        switch quickActionsState.selectedAction {
        case .one:
            return .red
        case .two:
            return .blue
        case .three:
            return .yellow
        case .four:
            return .indigo
        case .five:
            return .mint
        case .none:
            return .white
        }
    }

    // 背景色には上記で用意したbackgroundColorを使用
    // 表示するImageのシンボルにはQuickAction.imageNameを渡す
    // selectedActionがnilの場合にはImageは表示されない
    var body: some View {
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                    .ignoresSafeArea()

                VStack {
                    // クイックアクションが選択されている場合
                    if let action = quickActionsState.selectedAction {
                        Image(systemName: action.imageName)
                            .resizable()
                            .frame(width: 100, height: 100)

                        Text("Selected Action: \(action.rawValue)")  // 現在のアクションを表示。クイックアクションを使用した場合
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    } else {
                        Text("No Action Selected")  // アクションが選択されていない場合の表示。アプリを開いた時
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            showConfiguration.toggle()
                        }
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
        }
        if showConfiguration {
            Configure(showConfiguration: $showConfiguration)
                .environmentObject(quickActionsState)
        }
    }
}

#Preview {
    ContentView()
}
