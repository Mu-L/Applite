//
//  BrewInfoView.swift
//  Applite
//
//  Created by Milán Várady on 2025.01.01.
//

import SwiftUI

struct BrewInfoView: View {
    // These will be loaded in asynchronously (nil = still loading)
    @State var homebrewVersion: String? = nil
    @State var numberOfCasks: String? = nil

    var body: some View {
        Section("Info") {
            LabeledContent("Homebrew Version") {
                infoValue(homebrewVersion)
            }

            LabeledContent("Apps Installed") {
                infoValue(numberOfCasks)
            }
        }
        .task {
            // Get version
            guard let versionOutput = try? await Shell.runBrewCommand(["--version"]),
                  let version = versionOutput.firstMatch(of: /Homebrew ([\d\.]+)/),
                  let casksInstalled = try? await Shell.runBrewCommand(["list", "--cask", "--full-name", "|", "wc", "-w"]) else {

                homebrewVersion = String(localized: "Error", comment: "Brew info value when loading fails")
                numberOfCasks = String(localized: "Error", comment: "Brew info value when loading fails")
                return
            }

            homebrewVersion = String(version.1)
            numberOfCasks = casksInstalled.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    @ViewBuilder
    private func infoValue(_ value: String?) -> some View {
        if let value {
            Text(value)
        } else {
            ProgressView()
                .controlSize(.small)
        }
    }
}
