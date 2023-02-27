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
    @State private var batters: [ExtendedBatter] = []
    @State private var loadingError: Error?
    @State private var answerTest: String?
    @State private var projection: ProjectionTypes = .steamer
    @State private var position: Position = .ss
    @State private var showSpinner: Bool = false

    var body: some View {
        ZStack {
            List {
                Picker("Projection", selection: $projection) {
                    ForEach(ProjectionTypes.batterArr, id: \.self) { proj in
                        Text(proj.title).tag(proj)
                    }
                }

                Picker("Position", selection: $position) {
                    ForEach(Position.batters, id: \.self) { pos in
                        Text(pos.str.uppercased()).tag(pos)
                    }
                }
                
                Section("Last updated") {
                    if let lastUpdated = UserDefaults.lastUpdated(for: projection, and: position) {
                        Text(lastUpdated.getFormattedDate(format: .abreviatedMonth))
                        
                    } else {
                        Text("Never")
                    }
                }
                
                Button("Read") {
                    UserDefaults.updateIfNecessary(for: projection, and: position)
                    
                    DispatchQueue.main.async {
                        showSpinner = true
                    }
                    
                    DispatchQueue.global().async {
                        getAllChildNodes(parentNode: projection.str) { result in
                            switch result {
                                case let .success(batters):
                                    self.batters = batters
                                case let .failure(error):
                                    self.loadingError = error
                            }
                            DispatchQueue.main.async {
                                showSpinner = false
                            }
                            
                        }
                    }
                    
                }
                
                Section("Positions needing update") {
                    ForEach(UserDefaults.needingUpdate().indices, id: \.self) { index in
                        
                        return Text("\(UserDefaults.needingUpdate()[index].projection.title) \(UserDefaults.needingUpdate()[index].position.str.uppercased()) ")
                    }
                }

                
                
                ForEach(batters, id: \.self) { download in
                    Text(download.description)
                }
                
                
            }
            
            if showSpinner {
                ProgressView()
            }
        }
    }

    func getAllChildNodes(parentNode: String, completion: @escaping (Result<[ExtendedBatter], Error>) -> Void) {
        let ref = Database.database().reference()
        let parentRef = ref.child(parentNode).child(position.str)

        parentRef.observeSingleEvent(of: .value) { snapshot in
            var childNodes = [ExtendedBatter]()
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: childSnapshot.value as Any),
                       let batter = try? JSONDecoder().decode(ExtendedBatter.self, from: jsonData) {
                        childNodes.append(batter)
                    } else {
                        print("cant do it")
                    }
                }
            }
            completion(.success(childNodes))
        } withCancel: { error in
            completion(.failure(error))
        }
    }

//    func readValue(_ completion: @escaping ([ExtendedBatter]) -> Void) {
//        let ref = Database.database().reference()
//        var batters = [ExtendedBatter]()
//
//        var count = 0
//
//        let posArr = ref.child(projection.str).child(position.str)
//
//        posArr.getData { err, snapshot in
//            guard let data = snapshot.obser else {
//                return
//            }
//        }
//
//
    ////        posArr.observeSingleEvent(of: .value) { snap, _ in
    ////            guard let count = snap.childrenCount  else {
    ////                return
    ////            }
    ////
    ////
    ////            for ind in 0 ... count {
    ////
    ////                ref.child("\(ind)").observeSingleEvent(of: .value) { secondSnap in
    ////                    if let batter = try? secondSnap.data(as: ExtendedBatter.self) {
    ////                        batters.append(batter)
    ////                    }
    ////                    if ind == count {
    ////                        completion(batters)
    ////                    }
    ////                }
    ////            }
    ////            print("Batters is now", batters)
    ////        }
//    }
}

// MARK: - NVDownloadBatters_Previews

struct NVDownloadBatters_Previews: PreviewProvider {
    static var previews: some View {
        NVDownloadBatters()
    }
}
