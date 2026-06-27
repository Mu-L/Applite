//
//  ErrorWindowView.swift
//  Applite
//
//  Created by Milán Várady on 2023. 08. 25..
//

import SwiftUI

struct ErrorWindowView: View {
    let errorString: String

    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Label("Terminal Output", systemImage: "terminal")
                        .font(.headline)

                    Text("This is the output from the failed command. Copy it when reporting an issue.", comment: "Error window description")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    errorString.copyToClipboard()
                    withAnimation { copied = true }

                    Task {
                        try? await Task.sleep(for: .seconds(1.5))
                        withAnimation { copied = false }
                    }
                } label: {
                    Label(copied ? "Copied" : "Copy", systemImage: copied ? "checkmark" : "doc.on.doc")
                }
            }
            .padding()

            Divider()

            ScrollView {
                Text(errorString)
                    .monospaced()
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
        }
    }
}

#Preview {
    ErrorWindowView(errorString: "Error: This is just an example")
}
