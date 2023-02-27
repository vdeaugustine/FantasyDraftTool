//
//  NVSettings.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/22/23.
//

import SwiftUI

// MARK: - NVSettings

struct NVSettings: View {
    @EnvironmentObject private var model: MainModel
    @State private var positionLimit = UserDefaults.positionLimit

    var body: some View {
        List {
            Section("Limits") {
//                Picker("Position Limit", selection: $positionLimit) {
//                    ForEach(30 ... 100, id: \.self) { num in
//                        if num.isMultiple(of: 5) {
//                            Text(num.str)
////                                .tag(num.str)
//                        }
//                    }
//                }

                Picker("Outfield Limit", selection: $positionLimit) {
                    ForEach(50 ... 250, id: \.self) { num in
                        if num.isMultiple(of: 5) {
                            Text("\(num)")
                                .tag(num)
                        }
                    }
                }
                .onChange(of: positionLimit) { newVal in

                    UserDefaults.positionLimit = newVal
                }
                
                NavigationLink {
                    NVDownloadBatters()
                } label: {
                    Text("Download")
                }
            }
        }
    }
}

// MARK: - NVSettings_Previews

struct NVSettings_Previews: PreviewProvider {
    static var previews: some View {
        NVSettings()
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
