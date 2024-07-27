//
//  SettingsView.swift
//  Crypro
//
//  Created by Antomated on 20.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(Constants.selectedTheme) private var darkThemeIsOn: Bool = defaultDarkMode
    @Binding var isPresented: Bool

    private let personalURL = URL(string: Constants.gitHubURL)!
    private static var defaultDarkMode: Bool {
        UITraitCollection.current.userInterfaceStyle == .dark
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                List {
                    appSection
                    themeSection
                }
                .navigationBarTitleDisplayMode(.inline)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(LocalizationKey.information.localizedString)
                        .font(.chakraPetch(.bold, size: 24))
                        .tracking(2)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresented = false
                    } label: {
                        SystemImage.xMark.image
                            .bold()
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
            HStack(spacing: 4) {
                Spacer()
                VStack(alignment: .center, content: {
                    Image(.logo)
                        .resizable()
                        .frame(width: 120, height: 120)
                    Text(Constants.appName)
                        .font(.chakraPetch(.bold, size: 16))
                        .tracking(4)
                        .foregroundStyle(Color.launch.accent)
                })
                Spacer()
                VStack(alignment: .center) {
                    Spacer()
                    Text(LocalizationKey.appDescription.localizedString)
                        .font(.chakraPetch(.medium, size: 12))
                        .tracking(1)
                        .foregroundStyle(Color.theme.accent)
                    Spacer()
                    Link(destination: personalURL) {
                        Text(LocalizationKey.visitGitHub.localizedString)
                            .frame(width: 150)
                            .font(.chakraPetch(.bold, size: 16))
                            .tracking(2)
                            .foregroundStyle(Color.theme.accent)
                            .padding(.vertical, 7)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.secondary.opacity(0.25))
                            )
                    }
                }
                Spacer()
            }
            .padding(.vertical)
        }
    }

    var themeSection: some View {
        Section {
            HStack {
                Toggle(isOn: $darkThemeIsOn) {
                    Text(LocalizationKey.darkTheme.localizedString)
                        .font(.chakraPetch(.bold, size: 16))
                        .tracking(1)
                }
                .padding()
                .toggleStyle(SwitchToggleStyle(tint: Color.theme.green))
            }
        } header: {
            HStack {
                Spacer()
                Text(LocalizationKey.settings.localizedString)
                    .foregroundStyle(Color.theme.accent)
                    .font(.chakraPetch(.bold, size: 24))
                    .tracking(1)
                    .padding(.bottom)
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
