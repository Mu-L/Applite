//
//  UpdateSettingsView.swift
//  Applite
//
//  Created by Milán Várady on 2024.12.26.
//

import SwiftUI
import Sparkle

struct UpdateSettingsView: View {
    private let updater: SPUUpdater

    @State private var automaticallyChecksForUpdates: Bool
    @State private var automaticallyDownloadsUpdates: Bool

    init(updater: SPUUpdater) {
        self.updater = updater
        self.automaticallyChecksForUpdates = updater.automaticallyChecksForUpdates
        self.automaticallyDownloadsUpdates = updater.automaticallyDownloadsUpdates
    }

    var body: some View {
        Form {
            Section {
                Button(action: updater.checkForUpdates) {
                    Label("Check for Updates...", systemImage: "arrow.triangle.2.circlepath")
                }

                LabeledContent("Current app version") {
                    Text("\(Bundle.main.version) (\(Bundle.main.buildNumber))", comment: "Update settings current app version text (version, build number)")
                }
            }

            Section {
                Toggle("Automatically check for updates", isOn: $automaticallyChecksForUpdates)
                    .onChange(of: automaticallyChecksForUpdates) { _, newValue in
                        updater.automaticallyChecksForUpdates = newValue
                    }

                Toggle("Automatically download updates", isOn: $automaticallyDownloadsUpdates)
                    .disabled(!automaticallyChecksForUpdates)
                    .onChange(of: automaticallyDownloadsUpdates) { _, newValue in
                        updater.automaticallyDownloadsUpdates = newValue
                    }
            }
        }
        .formStyle(.grouped)
    }
}
