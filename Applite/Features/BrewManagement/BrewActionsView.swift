//
//  BrewActionsView.swift
//  Applite
//
//  Created by Milán Várady on 2025.01.01.
//

import SwiftUI
import ButtonKit

struct BrewActionsView: View {
    @Binding var modifyingBrew: Bool

    @State var updateDone = false
    @State var reinstallDone = false

    @State var isAppBrewInstalled = false

    @State var isPresentingReinstallConfirm = false

    @State var updateFailed = false
    @State var reinstallFailed = false

    var body: some View {
        Group {
            Section {
                updateButton

                remark(
                    title: "Warning",
                    color: .orange,
                    message: "All other app functions will be disabled during the update!"
                )
            } header: {
                Text("Update", comment: "Brew Management view update section title")
            }

            Section {
                reinstallButton

                remark(
                    title: "Note",
                    color: .blue,
                    message: "This will (re)install Applite's Homebrew installation at: `~/Library/Application Support/Applite/homebrew`"
                )

                remark(
                    title: "Warning",
                    color: .orange,
                    message: "After reinstalling, all currently installed apps will be unlinked from Applite. They won't be deleted, but you won't be able to update or uninstall them via Applite."
                )
            } header: {
                Text("Reinstall", comment: "Brew Management view reinstall section title")
            }
        }
        .task {
            // Check if brew is installed in application support
            isAppBrewInstalled = await BrewPaths.isBrewPathValid(at: BrewPaths.getBrewExectuablePath(for: .appPath))
        }
    }

    private func remark(title: LocalizedStringKey, color: Color, message: LocalizedStringKey) -> Text {
        Text(title)
            .foregroundStyle(color)
            .fontWeight(.bold)
        +
        Text(": ")
            .foregroundStyle(color)
            .fontWeight(.bold)
        +
        Text(message)
    }

    @MainActor
    private var updateButton: some View {
        HStack {
            AsyncButton {
                try await updateHomebrew()
            } label: {
                Label("Update Homebrew", systemImage: "arrow.uturn.down.circle")
            }
            .controlSize(.large)
            .disabled(modifyingBrew)
            .onButtonStateError { error in
                BrewManagementView.logger.error("Brew update failed. Error: \(error.error.localizedDescription)")
                updateFailed = true
            }
            .alert("Update failed", isPresented: $updateFailed, actions: {})

            // Success checkmark
            if updateDone {
                Image(systemName: "checkmark.circle")
                    .imageScale(.large)
                    .foregroundStyle(.green)
            }
        }
    }

    @MainActor
    private var reinstallButton: some View {
        HStack {
            Button(role: .destructive) {
                isPresentingReinstallConfirm = true
            } label: {
                Label(isAppBrewInstalled ? "Reinstall Homebrew" : "Install Separate Brew", systemImage: "wrench.and.screwdriver")
            }
            .controlSize(.large)
            .disabled(modifyingBrew)
            .confirmationDialog("Are you sure you want to \(isAppBrewInstalled ? "re" : "")install Homebrew?", isPresented: $isPresentingReinstallConfirm) {
                AsyncButton("Reinstall", role: .destructive) {
                    withAnimation {
                        modifyingBrew = true
                    }

                    do {
                        try await DependencyManager.installHomebrew()
                    } catch {
                        reinstallFailed = true
                    }

                    if !reinstallFailed {
                        reinstallDone = true
                    }

                    withAnimation {
                        modifyingBrew = false
                    }
                }

                Button("Cancel", role: .cancel) { }
            } message: {
                if isAppBrewInstalled {
                    Text("All currently installed apps will be unlinked from Applite.", comment: "Brew reinstallation alert warning")
                } else {
                    Text("A new Homebrew installation will be installed into `~/Library/Application Support/Applite`", comment: "Brew installation alert notice")
                }
            }
            .alert("Reinstall failed", isPresented: $reinstallFailed, actions: {
                Button("OK", role: .cancel) { }
            })

            // Success checkmark
            if reinstallDone {
                Image(systemName: "checkmark.circle")
                    .imageScale(.large)
                    .foregroundStyle(.green)
            }
        }
    }

    func updateHomebrew() async throws {
        withAnimation {
            modifyingBrew = true
        }

        BrewManagementView.logger.info("Updating brew started")

        try await Shell.runBrewCommand(["update"])

        BrewManagementView.logger.info("Brew update successful")

        updateDone = true

        withAnimation {
            modifyingBrew = false
        }
    }
}
