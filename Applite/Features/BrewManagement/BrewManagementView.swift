//
//  BrewManagementView.swift
//  Applite
//
//  Created by Milán Várady on 2023. 06. 09..
//

import SwiftUI
import OSLog

/// Displays info and provides tools to manage brew installation
struct BrewManagementView: View {
    @Binding var modifyingBrew: Bool

    static let logger = Logger()

    var body: some View {
        Form {
            Section {
                Text(
                    "Applite is powered by [Homebrew](https://brew.sh/), a free and open-source tool that installs and keeps your apps up to date behind the scenes. You don't need to set it up or use it directly — Applite takes care of everything for you.",
                    comment: "Manage Homebrew view description"
                )
            }

            BrewInfoView()

            BrewActionsView(modifyingBrew: $modifyingBrew)
        }
        .formStyle(.grouped)
        .navigationTitle("Manage Homebrew")
    }
}

#Preview {
    BrewManagementView(modifyingBrew: .constant(false))
}
