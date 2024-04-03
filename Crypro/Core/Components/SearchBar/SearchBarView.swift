//
//  SearchBarView.swift
//  Crypro
//
//  Created by Anton Petrov on 03.04.2024.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                )

            TextField("Search by name or symbol...", text: $searchText)
                .foregroundStyle(Color.theme.accent)
                .autocorrectionDisabled()
                .keyboardType(.alphabet)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    , alignment: .trailing
                )
        }
        .font(.callout)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.theme.secondaryText)
        )
    }
}

#Preview {
    Group {
        SearchBarView(searchText: .constant(""))
            .preferredColorScheme(.dark)
    }
}
