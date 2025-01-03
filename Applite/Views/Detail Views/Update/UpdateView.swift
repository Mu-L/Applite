//
//  UpdateView.swift
//  Applite
//
//  Created by Milán Várady on 2022. 10. 14..
//

import SwiftUI
import Fuse

/// Update section
struct UpdateView: View {
    @EnvironmentObject var caskManager: CaskManager
    
    @State var searchText = ""
    @State var refreshing = false
    @State var isUpdatingAll = false
    @State var updateAllButtonRotation = 0.0
    
    @State var showingGreedyUpdateConfirm = false
    @StateObject var loadAlert = AlertManager()

    // Filter outdated casks
    var casks: [Cask] {
        var outdatedCasks = caskManager.outdatedCasks
        if !$searchText.wrappedValue.isEmpty {
            outdatedCasks = outdatedCasks.filter {
                (fuseSearch.search(searchText, in: $0.info.name)?.score ?? 1) < 0.4
            }
        }

        let outdatedCasksAphabetical = Array(outdatedCasks).sorted { $0.info.name < $1.info.name }

        return outdatedCasksAphabetical
    }
    
    let fuseSearch = Fuse()

    var body: some View {
        ScrollView {
            // App grid
            AppGridView(casks: Array(caskManager.outdatedCasks), appRole: .update)
                .padding()
            
            if casks.count > 1 {
                updateAllButton
            } else {
                updateUnavailable
            }
        }
        .searchable(text: $searchText)
        .toolbar {
            toolbarItems
        }
        .alertManager(loadAlert)
    }
}

struct UpdateView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateView()
            .environmentObject(CaskManager())
            .frame(width: 500, height: 400)
    }
}
