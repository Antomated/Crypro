//
//  DetailLoadingView.swift
//  Crypro
//
//  Created by Beavean on 07.06.2024.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}
