//
//  CaskInfoWindowView.swift
//  Applite
//
//  Created by Milán Várady on 2025.01.02.
//

import SwiftUI

struct CaskInfoWindowView: View {
    let info: CaskAdditionalInfo

    var body: some View {
        Form {
            Section {
                infoRow("Token", info.token)
                infoRow("Full Token", info.full_token)
                infoRow("Tap", info.tap)

                linkRow("Homepage", url: info.homepage)

                linkRow("Download URL", url: info.url)
            } header: {
                Label("General", systemImage: "info.circle")
            }

            Section {
                infoRow("Installed Version", info.installed ?? String(localized: "Not installed", comment: "Cask info: app is not installed"))
                infoRow("Bundle Version", info.bundle_version ?? "—")

                if let installedTime = info.installed_time {
                    infoRow("Installation Date", dateFormatter.string(from: installedTime))
                }

                if let outdated = info.outdated {
                    infoRow("Outdated", yesNo(outdated))
                }

                infoRow("Auto Updates", yesNo(info.auto_updates ?? false))
            } header: {
                Label("Installation", systemImage: "arrow.down.circle")
            }

            if info.deprecated {
                Section {
                    if let date = info.deprecation_date {
                        infoRow("Date", date)
                    }
                    if let reason = info.deprecation_reason {
                        infoRow("Reason", reason)
                    }
                    if let replacement = info.deprecation_replacement {
                        infoRow("Replacement", replacement)
                    }
                } header: {
                    Label("Deprecated", systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                }
            }

            if info.disabled {
                Section {
                    if let date = info.disable_date {
                        infoRow("Date", date)
                    }
                    if let reason = info.disable_reason {
                        infoRow("Reason", reason)
                    }
                    if let replacement = info.disable_replacement {
                        infoRow("Replacement", replacement)
                    }
                } header: {
                    Label("Disabled", systemImage: "xmark.octagon.fill")
                        .foregroundStyle(.red)
                }
            }
        }
        .formStyle(.grouped)
        .navigationTitle(info.token)
        .frame(width: 460, height: 520)
    }

    private func infoRow(_ title: LocalizedStringKey, _ value: String) -> some View {
        LabeledContent(title) {
            Text(value)
                .textSelection(.enabled)
        }
    }

    /// A row for long URLs: the label sits on top with the link wrapping
    /// full-width on the line below, left-aligned.
    private func linkRow(_ title: LocalizedStringKey, url: URL) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)

            Link(url.absoluteString, destination: url)
                .multilineTextAlignment(.leading)
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func yesNo(_ value: Bool) -> String {
        value
            ? String(localized: "Yes", comment: "Cask info boolean value")
            : String(localized: "No", comment: "Cask info boolean value")
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    CaskInfoWindowView(info: .dummy)
}
