//
//  String+Clipboard.swift
//  Applite
//
//  Created by Milán Várady on 2025.01.02.
//

import AppKit

extension String {
    /// Copies the string to the system clipboard (general pasteboard).
    func copyToClipboard() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(self, forType: .string)
    }
}
