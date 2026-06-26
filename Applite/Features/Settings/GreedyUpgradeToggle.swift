//
//  GreedyUpgradeToggle.swift
//  Applite
//
//  Created by Milán Várady on 2025.05.09.
//

import SwiftUI

struct GreedyUpgradeToggle: View {
    /// How the explanation is presented alongside the toggle.
    enum DescriptionPlacement {
        /// Caption beneath the title — fits a grouped `Form` (Settings).
        case inline
        /// Info popover beside the title — fits compact contexts (toolbar).
        case popover
    }

    var descriptionPlacement: DescriptionPlacement = .inline

    @AppStorage(Preferences.greedyUpgrade) var greedyUpgrade

    var body: some View {
        Toggle(isOn: $greedyUpgrade) {
            switch descriptionPlacement {
            case .inline:
                VStack(alignment: .leading, spacing: 2) {
                    Text("Include Self-Updating Apps", comment: "Brew greedy flag toggle title")
                    Text("Show updates for apps that normally update themselves, which are hidden by default. (Homebrew: `--greedy`)", comment: "Brew greedy flag toggle description")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            case .popover:
                HStack {
                    Text("Include Self-Updating Apps", comment: "Brew greedy flag toggle title")

                    InfoPopup(
                        text: "Show updates for apps that normally update themselves, which are hidden by default. (Homebrew: `--greedy`)",
                        extraPaddingForLines: 3
                    )
                }
            }
        }
    }
}
