//
//  SettingsView.swift
//  Crypro
//
//  Created by Anton Petrov on 20.04.2024.
//
// TODO: Constants

import SwiftUI

struct SettingsView: View {
    let personalURL = URL(string: "https://github.com/beavean")!
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                List {
                    appSection
                }
            }
            .navigationTitle("Information")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
            }
            .foregroundColor(.theme.accent)
        }
    }
}

// MARK: - COMPONENTS

private extension SettingsView {
    var appSection: some View {
        Section {
            HStack(spacing: 16) {
                VStack(alignment: .center, content: {
                    Image("logo")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Text("CRYPRO")
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(Color.launch.accent)
                })
                VStack(alignment: .center) {
                    Spacer()
                    Text("The application displays information and statistics for top crypto coins with portfolio tracking functionality.")
                        .font(.caption2.weight(.medium))
                    .foregroundStyle(Color.theme.accent)
                    Spacer()
                    Text("""
                        Developed by @beavean
                        """)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Color.theme.accent)
                    Link(destination: personalURL) {
                        Text("Visit GitHub")
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                            .foregroundStyle(Color.theme.accent)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.secondary.opacity(0.25))
                                    .frame(maxWidth: .infinity)
                            )
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

// MARK: - PREVIEW

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
