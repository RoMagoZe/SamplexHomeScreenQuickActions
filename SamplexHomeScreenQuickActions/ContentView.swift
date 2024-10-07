//
//  ContentView.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/09/29.
//

import SwiftUI

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
