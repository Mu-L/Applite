//
//  UninstallView.swift
//  Applite
//
//  Created by Milán Várady on 2024.12.26.
//

import SwiftUI

struct UninstallView: View {
    @Environment(\.openWindow) var openWindow

    var body: some View {
        Form {
            Section {
                Button(role: .destructive) {
                    openWindow(id: "uninstall-self")
                } label: {
                    Label("Uninstall Applite", systemImage: "trash")
                        .foregroundStyle(.red)
                }
            } footer: {
                Text("Uninstall Applite, related files and cache.", comment: "Settings Uninstall Applite view description")
            }
        }
        .formStyle(.grouped)
    }
}
