//
//  SettingsView.swift
//  Crypro
//
//  Created by Beavean on 20.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(Constants.selectedTheme) private var darkThemeIsOn: Bool = defaultDarkMode
    @Binding var isPresented: Bool

    private let personalURL = URL(string: Constants.gitHubUrl)!
    private static var defaultDarkMode: Bool {
        UITraitCollection.current.userInterfaceStyle == .dark
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                List {
                    appSection
                    themeSection
                }
            }
            .navigationTitle(LocalizationKey.information.localizedString)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        SystemImage.xMark.image
                            .font(.headline)
                    }
                }
            }
            .foregroundColor(.theme.accent)
            .preferredColorScheme(darkThemeIsOn == true ? .dark : .light)
        }
    }
}

// MARK: - UI Components

private extension SettingsView {
    var appSection: some View {
        Section {
            HStack(spacing: 16) {
                VStack(alignment: .center, content: {
                    Image(.logo)
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

    var themeSection: some View {
        Section {
            HStack {
                Toggle(isOn: $darkThemeIsOn) {
                    Text(LocalizationKey.darkTheme.localizedString)
                        .font(.body.weight(.bold))
                }
                .padding()
                .toggleStyle(SwitchToggleStyle(tint: Color.theme.green))
            }
        } header: {
            HStack {
                Spacer()
                Text(LocalizationKey.settings.localizedString)
                    .font(.headline)
                    .foregroundStyle(Color.theme.secondaryText)
                Spacer()
            }
        }
        .textCase(.none)
    }
}

#Preview {
    SettingsView(isPresented: .constant(true))
        .preferredColorScheme(.dark)
}
