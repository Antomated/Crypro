//
//  SettingsView.swift
//  Crypro
//
//  Created by Anton Petrov on 20.04.2024.
//
// TODO: Constants

import SwiftUI

struct SettingsView: View {
    let personalURL = URL(string: Constants.gitHubUrl)!
    @Environment(\.dismiss) var dismiss

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
                        dismiss()
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
                    Text(Constants.appName)
                        .font(.headline.weight(.heavy))
                        .foregroundStyle(Color.launch.accent)
                })
                VStack(alignment: .center) {
                    Spacer()
                    Text(LocalizationKey.appDescription.localizedString)
                        .font(.caption2.weight(.medium))
                    .foregroundStyle(Color.theme.accent)
                    Spacer()
                    Text(LocalizationKey.developedBy.localizedString + Constants.gitHubNickname)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(Color.theme.accent)
                    Link(destination: personalURL) {
                        Text(LocalizationKey.visitGitHub.localizedString)
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
