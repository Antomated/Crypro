//
//  CrossButton.swift
//  Crypro
//
//  Created by Anton Petrov on 04.04.2024.
//

import SwiftUI

struct CrossButton: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var viewModel: HomeViewModel

    var body: some View {
        Button {
            viewModel.selectedCoin = nil
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

#Preview {
    CrossButton()
}
