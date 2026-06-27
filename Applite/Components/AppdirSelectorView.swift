//
//  AppdirSelectorView.swift
//  Applite
//
//  Created by Milán Várady on 2023. 08. 25..
//

import SwiftUI

struct AppdirSelectorView: View {
    @AppStorage(Preferences.appdirOn) var appdirOn
    @AppStorage(Preferences.appdirPath) var appdirPath
    
    @State var choosingAppdir = false
    
    var body: some View {
        Toggle(isOn: $appdirOn) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Use Custom Installation Directory")
                Text("Install apps to a folder of your choice instead of /Applications. (Homebrew: `--appdir`)", comment: "Appdir setting description")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }

        HStack {
            TextField("Installation Directory", text: $appdirPath, prompt: Text("/path/to/dir"))
                .labelsHidden()
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            Button("Select Folder") {
                choosingAppdir = true
            }
            .fileImporter(
                isPresented: $choosingAppdir,
                allowedContentTypes: [.directory]
            ) { result in
                switch result {
                case .success(let file):
                    appdirPath = file.path
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        .disabled(!appdirOn)
    }
}

#Preview {
    AppdirSelectorView()
}
