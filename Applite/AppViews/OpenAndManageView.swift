//
//  OpenAndManageView.swift
//  Applite
//
//  Created by Milán Várady on 2024.12.26.
//

import SwiftUI
import ButtonKit

/// Button used in the Download section, launches, uninstalls or reinstalls the app
struct OpenAndManageView: View {
    var cask: CaskViewModel
    let deleteButton: Bool

    @State var showAppNotFoundAlert = false

    var body: some View {
        // Lauch app
        AsyncButton("Open") {
            try await cask.launchApp()
        }
        .font(.system(size: 14))
        .buttonStyle(.bordered)
        .clipShape(Capsule())
        .onButtonStateError { error in
            showAppNotFoundAlert = true
        }
        .asyncButtonStyle(.none)
        .alert("Applite couldn't open \(cask.name)", isPresented: $showAppNotFoundAlert) {}

        if deleteButton {
            UninstallButton(cask: cask)
        }
    }
}
