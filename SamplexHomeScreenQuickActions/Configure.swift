//
//  Configure.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/10/06.
//

import SwiftUI

struct Configure: View {
    // 親ビューから受け取るBinding変数で、設定画面の表示・非表示を制御
    @Binding var showConfiguration: Bool
    // クイックアクションの全ケースをリストに表示するための配列
    let classifications = QuickAction.allCases
    // 環境オブジェクトとしてQuickActionStateを取得し、アクションの選択状態を管理
    @EnvironmentObject var quickActionState: QuickActionState

    var body: some View {
        // ナビゲーションビュー内で設定画面を表示
        NavigationView {
            // 全てのクイックアクションをリストとして表示
            List(classifications, id: \.self) { action in
                HStack {
                    // クイックアクション名を表示
                    Text(action.rawValue.capitalized)
                    Spacer()
                    // チェックボックスボタンを表示し、アクションを選択または解除
                    Button {
                        quickActionState.toggleAction(action)
                    } label: {
                        // 選択されているかどうかでチェックマークを切り替え
                        Image(systemName: quickActionState.selectedActions.contains(action)
                              ? "checkmark.square.fill"
                              : "square"
                        )
                    }
                }
            }
            .navigationTitle("カスタムアクション")
            .toolbar {
                // ツールバーの右上に閉じるボタンを配置
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // ボタンが押された時に画面を閉じる
                        showConfiguration.toggle()
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                }
            }
        }
    }
}
