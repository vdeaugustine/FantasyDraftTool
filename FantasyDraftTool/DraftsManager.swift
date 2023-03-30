//
//  File.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/19/23.
//

import Foundation







class DraftsManager: ObservableObject {
    var shared = DraftsManager()
    @Published var draftsKeys: Set<String> = []
    var draftsSaved: [Draft] {
        var retArr = [Draft]()
        for key in draftsKeys {
            if let foundData = UserDefaults.standard.data(forKey: key) {
                do {
                    let decoder = JSONDecoder()
                    let decodedDraft = try decoder.decode(Draft.self, from: foundData)
                    retArr.append(decodedDraft)
                } catch {
                    print(error)
                }
            }
        }
        return retArr
    }

    func key(for draft: Draft) -> String {
        [draft.leagueName, draft.creationDate.getFormattedDate(format: .abreviatedMonthAndMinimalTime)].joinString("-")
    }

    func saveDraft(_ draft: Draft) {
        let key = key(for: draft)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(draft)
            UserDefaults.standard.set(data, forKey: key)
            draftsKeys.insert(key)
        } catch {
            print(error)
        }
    }
}
