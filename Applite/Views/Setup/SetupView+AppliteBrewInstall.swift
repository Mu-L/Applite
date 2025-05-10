//
//  SetupView+AppliteBrewInstall.swift
//  Applite
//
//  Created by Milán Várady on 2024.12.26.
//

import SwiftUI
import ButtonKit

extension SetupView {
    /// Brew installation page
    struct AppliteBrewInstall: View {
        @Environment(\.openURL) var openURL

        /// This is needed so the parent view knows it can continue to the next page
        @Binding var isDone: Bool

        @State var failed = false

        // Alerts
        @State var showCommandLineToolsInstallAlert = false
        @StateObject var installAlert = AlertManager()

        @StateObject var installationProgress = BrewInstallationProgress()

        var body: some View {
            VStack {
                Text("Installing dependencies", comment: "Brew dependency installation view title")
                    .font(.appliteSmallTitle)
                    .padding(.vertical)
                    .padding(.top, 10)

                // Xcode Command Line Tools
                VStack(alignment: .leading, spacing: 20) {
                    // Xcode Command Line Tools
                    dependencyView(title: "Xcode Command Line Tools",
                                   description: "You will be prompted to install the Xcode Command Line Tools, please click \"Install\" as it is required for this application to work. It will take a few minutes, you can see the progress on the installation window.",
                                   progressOrder: .waitingForXcodeCommandLineTools)


                    // Homebrew
                    dependencyView(title: "Homebrew",
                                   description: "[Homebrew](https://brew.sh) is a free and open source package manager tool that makes installing third-party applications really easy. Applite uses Homebrew under the hood to download and manage applications.",
                                   progressOrder: .fetchingHomebrew)

                    // Retry button
                    if failed {
                        AsyncButton {
                            await installDependencies()
                        } label: {
                            Label("Retry Install", systemImage: "arrow.clockwise.circle")
                        }
                        .controlSize(.large)
                    }
                }
                .frame(width: 440)
                .task {
                    if await !BrewPaths.isCommandLineToolsInstalled() {
                        showCommandLineToolsInstallAlert = true
                    }

                    // Start installation when view loads
                    await installDependencies()
                }
                .alert("Xcode Command Line Tools", isPresented: $showCommandLineToolsInstallAlert) {} message: {
                    Text(
                        "You will be prompted to install Xcode Command Line Tools. Please select \"Install\" as it is required for this application to work.",
                        comment: "Brew dependency installation alert"
                    )
                }
                .alert(installAlert.title, isPresented: $installAlert.isPresented) {
                    Button("Troubleshooting", systemImage: "exclamationmark.magnifyingglass") {
                        openURL(URL(string: "https://aerolite.dev/applite/troubleshooting.html")!)
                    }

                    Button("Quit", role: .destructive) { NSApplication.shared.terminate(self) }
                } message: {
                    Text(installAlert.message)
                }
            }
        }

        private func dependencyView(title: LocalizedStringKey, description: LocalizedStringKey, progressOrder: InstallPhase) -> some View {
            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .padding(.trailing, 4)

                    if !failed {
                        if installationProgress.phase.rawValue > progressOrder.rawValue {
                            installedBadge
                        } else {
                            ProgressView()
                                .controlSize(.small)
                        }
                    } else {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                    }
                }
                .frame(height: 30)

                Text(description)
            }
        }

        private func installDependencies() async {
            // Reset progress
            failed = false
            installationProgress.phase = .waitingForXcodeCommandLineTools

            do {
                try await DependencyManager.install(progressObject: installationProgress)
            } catch {
                installAlert.show(title: "Installation failed", message: error.localizedDescription)
                failed = true
            }

            if !failed {
                self.isDone = true
            }
        }

        /// A little bagde that says "Installed"
        private var installedBadge: some View {
            HStack {
                Image(systemName: "checkmark")
                Text("Installed", comment: "Brew dependency installed badge text")
            }
            .padding(3)
            .foregroundColor(.white)
            .background(.green)
            .cornerRadius(4)
        }
    }
}
