//
//  HomeFooterView.swift
//  Crypro
//
//  Created by Antomated on 31.08.2024.
//

import SwiftUI

struct HomeFooterView: View {
    @Binding var showPortfolio: Bool
    @Binding var showEditView: Bool
    @Binding var showSettingsView: Bool

    var body: some View {
        HStack {
            CircleButtonView(icon: showPortfolio ? .plus : .info)
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    HapticManager.triggerSelection()
                    if showPortfolio {
                        showEditView = true
                    } else {
                        showSettingsView.toggle()
                    }
                }
            Spacer()
            CircleButtonView(icon: .chevronRight)
                .rotationEffect(.radians(showPortfolio ? .pi : 0))
                .onTapGesture {
                    HapticManager.triggerSelection()
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}
