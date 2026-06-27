//
//  ProxySettingsView.swift
//  Applite
//
//  Created by Milán Várady on 2024.12.26.
//

import SwiftUI

struct ProxySettingsView: View {
    @AppStorage(Preferences.networkProxyEnabled) var proxyEnabled
    @AppStorage(Preferences.preferredProxyType) var preferredProxyType

    var body: some View {
        Form {
            Section {
                Toggle("Use system proxy", isOn: $proxyEnabled)

                Picker("Preferred proxy protocol", selection: $preferredProxyType) {
                    ForEach(NetworkProxyType.allCases, id: \.self) { proxyType in
                        Text(proxyType.displayName)
                            .tag(proxyType.rawValue)
                    }
                }
            } footer: {
                Text(
                    "Applite can use the system network proxy, but only one protocol (HTTP, HTTPS, or SOCKS5). Select your preferred method.",
                    comment: "Proxy settings description"
                )
            }
        }
        .formStyle(.grouped)
    }
}
