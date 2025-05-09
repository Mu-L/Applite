//
//  CategoryViewModel+LocalizedName.swift
//  Applite
//
//  Created by Milán Várady on 2025.05.09.
//

import SwiftUICore

extension CategoryViewModel {
    var localizedName: LocalizedStringKey {
        LocalizedStringKey(self.name)
    }
}
