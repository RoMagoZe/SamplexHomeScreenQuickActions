//
//  Configure.swift
//  SamplexHomeScreenQuickActions
//
//  Created by Mina on 2024/10/06.
//

import SwiftUI

struct Configure: View {
    @Binding var showConfiguration: Bool
    let classifications = QuickAction.allCases
//    @State private var selectedActions: [QuickAction] = []
    @EnvironmentObject var quickActionState: QuickActionState

    var body: some View {
        NavigationView {
            List(classifications, id: \.self) { action in
                HStack {
                    Text(action.rawValue.capitalized)
                    Spacer()
                    Button {
                        quickActionState.toggleAction(action)
                    } label: {
                        Image(systemName: quickActionState.selectedActions.contains(action)
                              ? "checkmark.square.fill"
                              : "square"
                        )
                    }
                }
            }
            .navigationTitle("Configure Actions")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showConfiguration.toggle()
                    } label: {
                        Image(systemName: "x.circle.fill")
                    }
                }
            }
        }
    }
}
