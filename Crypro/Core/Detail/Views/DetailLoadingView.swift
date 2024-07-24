//
//  DetailLoadingView.swift
//  Crypro
//
//  Created by Antomated on 07.06.2024.
//

import SwiftUI

struct DetailLoadingView: View {
    var coin: Coin?

    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}
