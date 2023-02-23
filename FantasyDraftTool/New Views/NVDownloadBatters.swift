//
//  NVDownloadBatters.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/22/23.
//

import Firebase
import FirebaseCore
import FirebaseDatabaseSwift
import SwiftUI

// MARK: - ReaderManager

class ReaderManager: ObservableObject {
    var ref = Database.database().reference()
}

// MARK: - NVDownloadBatters

struct NVDownloadBatters: View {
    @State private var battersDownloaded: [ExtendedBatter] = []
    @State private var answerTest: String?

    var body: some View {
        List {
            ForEach(battersDownloaded, id: \.self) { download in
                Text(download.description)
            }

            Text(answerTest ?? "Nothing yet")
            Button("Read") {
                readValue { battersDownloaded = $0 }
            }
        }
        .onAppear {
            
        }
    }

    func readValue(_ completion: @escaping ([ExtendedBatter]) -> () ) {
        let ref = Database.database().reference()
        var batters = [ExtendedBatter]()

        var count = 0

        ref.child("count").observeSingleEvent(of: .value) { snap in
            guard let asInt = snap.value as? Int else { return }
                count = asInt
            
            
            for ind in 0 ... count {
                ref.child(ind.str).observeSingleEvent(of: .value) { snap in
                    if let batter = try? snap.data(as: ExtendedBatter.self) {
                        batters.append(batter)
                    }
                    if ind == count {
                        completion(batters)
                    }
                }
            }
            print("Batters is now", batters)
        }

        
        
    }
}

// MARK: - NVDownloadBatters_Previews

struct NVDownloadBatters_Previews: PreviewProvider {
    static var previews: some View {
        NVDownloadBatters()
    }
}
