//
//  NVDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVDraft

typealias BatterCompletion = ([ParsedBatter]) -> Void
typealias PitcherCompletion = ([ParsedPitcher]) -> Void
typealias PlayerCompletion = ([any ParsedPlayer]) -> Void

// MARK: - NVDraft

struct NVDraft: View {
    @EnvironmentObject private var model: MainModel
    @EnvironmentObject private var lm: LoadingManager
    @State private var projection: ProjectionTypes = .steamer
    @State private var sortOptionSelected: NVSortByDropDown.Options = .score

    @State private var positionSelected: Position? = nil
    @State private var showMyTeamQuickView = false
    @State private var showPlayerSheet = false
    @State private var batterForDetail: ParsedBatter? = nil
    @State private var numPicksToSim: Int = 50
    @State private var draftProgress: Double = -1
    @State private var loadingDone: Bool = true
    @State private var showDraftConfirmation = false
    @State private var playerToDraft: ParsedPlayer? = nil
    @State private var showMenu: Bool = false
    @State private var playerLimit: Int = 20
    @State private var pitchersAndBatters: [any ParsedPlayer] = []
    @State private var showSpinning = true

    func updatePlayers() async {
        print("Updating")
        
            lm.shouldShow = true
        
        
        filteredPlayers { filteredBatters in
            
            model.draft.playerPool.pitchers(types: [.starter, .reliever], projection: projection, draft: model.draft) { filteredPitchers in
                print("pitchers", filteredPitchers.count)
                
                let union: [any ParsedPlayer] = filteredBatters + filteredPitchers
                
                sortedPlayers(union) { sorted in
                    print("setting sorted", sorted.count)
                    pitchersAndBatters = sorted
                    DispatchQueue.main.async {
                        lm.taskPercentage = 1
                        showSpinning = false
                        lm.shouldShow = false
                    }
                }
                
                
            }
            
            
            
        }

        
        
    }

    func filteredPlayers(comletion: @escaping BatterCompletion) {
        print("starting filtering")
        DispatchQueue.main.async {
            lm.displayString = "Filtering Players"
        }

        DispatchQueue.global().async {
            // TODO: When switching
            var retaArr: [ParsedBatter] = []

            if let positionSelected = positionSelected {
                retaArr = model.draft.playerPool.batters(for: [positionSelected], projection: projection, draft: model.draft)

            } else {
                retaArr = model.draft.playerPool.batters(for: Position.batters, projection: projection, draft: model.draft)
            }
            
            let filtered = retaArr.filter {
                guard let adp = $0.adp else { return false }
                return Int(adp) <= model.draft.settings.totalPicksWillBeMade
            }
            
            comletion(filtered)
        }
        
    }

    func sortedPlayers(_ presorted: [any ParsedPlayer], completion: @escaping PlayerCompletion)  {
        print("starting sorting")
        DispatchQueue.main.async {
            lm.taskPercentage = 0
            lm.displayString = "Sorting..."
        }
        
        let n: Double = Double(presorted.count)
        let totalPossible: Double = n * log2(n)

        
        DispatchQueue.global().async {
            
            let retArr: [any ParsedPlayer]
            switch sortOptionSelected {
                case .points:
                    retArr = presorted.sorted { firstPlayer, secondPlayer in
                        let firstLimit = firstPlayer is ParsedBatter ? 50 : 100
                        let secLimit = secondPlayer is ParsedBatter ? 50 : 100
                        lm.incrementPercentage(1 / totalPossible)

                        return firstPlayer.weightedFantasyPoints(draft: model.draft, limit: firstLimit) > secondPlayer.weightedFantasyPoints(draft: model.draft, limit: secLimit)
                    }
                case .score:
                    retArr = presorted.sorted {
                        lm.incrementPercentage(1 / totalPossible)
                        return $0.wPointsZScore(draft: model.draft) > $1.wPointsZScore(draft: model.draft)
                    }
                default:
                retArr = presorted
            }
            completion(retArr)
            
        }
                
            
        
    }

    func bullet(_ text: String, color: Color? = nil) -> some View {
        HStack(spacing: 5) {
            Circle()
                .foregroundColor(color ?? .black)
                .height(5)
            Text(text)
        }
    }

    var draftConfirmationMessage: String {
        if let player = playerToDraft {
            return "Draft \(player.name) for \(model.draft.currentTeam.name)?"
        } else {
            return "Error. Please hit cancel"
        }
    }

//    func isFav(_ player: ParsedBatter) -> Bool {
//        model.draft.myStarPlayers.contains(player)
//    }

    func playerBox<T: ParsedPlayer>(_ player: T) -> some View {
        HStack(alignment: .center) {
            VStack(spacing: 10) {
                Button {
                    
                    if let pitcher = player as? ParsedPitcher {
                        print("peers", pitcher.peers(draft: model.draft).count, pitcher.peers(draft: model.draft))
                    } else if let batter = player as? ParsedBatter {
                        print("peers", batter.peers(draft: model.draft).count, batter.peers(draft: model.draft) )
                    } else {
                        print("uh oh ")
                    }
                    
                    
                    
                    
//                    model.draft.addOrRemoveStar(player)
                } label: {
                    Image(systemName: model.draft.isStar(player) ? "heart.fill" : "heart")
                        .foregroundColor(model.draft.isStar(player) ? Color.red : Color.black)
                        .font(.subheadline)
                }
                Button {
                    playerToDraft = player
                    showDraftConfirmation.toggle()

                    if let player = player as? ParsedBatter {
                        guard let firstPos = player.positions.first else {
                            return
                        }
                        print(player.name, "points", player.fantasyPoints(model.draft.settings.scoringSystem).str())
                        let otherPlayers = model.draft.playerPool.storedBatters.batters(for: player.projectionType, at: firstPos).prefixArray(10)
                        print("Position: \(firstPos.str)")
                        for otherPlayer in otherPlayers {
                            print(otherPlayer.name, "\(otherPlayer.fantasyPoints(model.draft.settings.scoringSystem))")
                        }
                        let average = ParsedBatter.averagePoints(forThese: otherPlayers, scoring: model.draft.settings.scoringSystem)
                        let secondAverage = model.draft.playerPool.storedBatters.average(for: player.projectionType, at: firstPos)
                        print("average for this position: ", average.str())
                        print("second for this position: ", secondAverage.str())
                        let stdDev = otherPlayers.standardDeviation(scoring: model.draft.settings.scoringSystem)
//                        print("std: ", stdDev.str())

                        let zScore = (player.fantasyPoints(model.draft.settings.scoringSystem) - average) / stdDev
//                        print("Z score", zScore.str())
                    }

                    if let player = player as? ParsedPitcher {
                        print(player.name, "points", player.fantasyPoints(model.draft.settings.scoringSystem).str())
                        let otherPlayers = model.draft.playerPool.storedPitchers.pitchers(for: player.projectionType, at: player.type, scoring: model.draft.settings.scoringSystem).prefixArray(40)
                        print("Position: \(player.type.str)")
                        for otherPlayer in otherPlayers {
                            print(otherPlayer.name, "\(otherPlayer.fantasyPoints(model.draft.settings.scoringSystem))")
                        }
                        let average = ParsedPitcher.averagePoints(forThese: otherPlayers, scoringSettings: model.draft.settings.scoringSystem)
                        print("average for this position: ", average.str())
                        let stdDev = otherPlayers.standardDeviation(scoring: model.draft.settings.scoringSystem)
                        print("std: ", stdDev.str())

                        let zScore = (player.fantasyPoints(model.draft.settings.scoringSystem) - average) / stdDev
//                        print("Z score", zScore.str())
                    }

                } label: {
                    Image(systemName: "checklist")

                        .font(.subheadline)
                }
            }.frame(maxHeight: .infinity)
            NVAllPlayersRow(player: player, draft: model.draft)
        }
        .padding(.horizontal)
        .background {
            Color.listBackground
                .cornerRadius(8)
                .shadow(radius: 0.7)
        }
    }

    var body: some View {
        if draftProgress < 1,
           draftProgress >= 0 {
            LoadingDraft(progress: $draftProgress)
                .padding()
        } else if !loadingDone {
            Text("Loading")
        } else {
            if let myTeam = model.draft.myTeam {
                ScrollView {
                    VStack {
                        Text("Total players = \(pitchersAndBatters.count)")
                        NVPicksSection()

                        VStack(alignment: .leading) {
                            Text("Filled")
                            HStack {
                                ForEach(Position.batters, id: \.self) { pos in

                                    LabelAndValueRect(label: pos.str.uppercased(), value: myTeam.players(for: pos).count.str, color: .white)
                                        .onChange(of: myTeam.players(for: pos)) { _ in
                                            print("myteam: ", myTeam.draftedPlayers)
                                            print(myTeam.players(for: pos))
                                        }
                                        .onAppear {
                                            print("Pick stack", model.draft.pickStack.getArray())
                                        }
                                }
                            }
                            .height(60)
                        }

                        HStack {
                            NVDropDownProjection(selection: $projection)
                                .onChange(of: projection) { _ in
                                    Task {
                                        await updatePlayers()
                                    }
                                }
                            NVSortByDropDown(selection: $sortOptionSelected)
                                .onChange(of: sortOptionSelected) { _ in
                                    Task {
                                        await updatePlayers()
                                    }
                                }
                            NVDropDownPosition(selection: $positionSelected)
                        }.pushLeft().padding(.top)

//                        if let recommended = myTeam.recommendedPlayer(draft: model.draft, projection: projection) {
//                            VStack(alignment: .leading) {
//                                Text("Recommended")
//                                playerBox(recommended)
//                            }
//                        }

                        // MARK: - Available Players

                        VStack(alignment: .leading) {
                            Text("Available")
                            if showSpinning {
                                ProgressView()
                            }
                            LazyVStack {
                                ForEach(pitchersAndBatters.indices, id: \.self) { playerInd in

                                    if let batter = pitchersAndBatters.safeGet(at: playerInd) as? ParsedBatter {
                                        Button {
                                            model.navPathForDrafting.append(batter)
                                        }
                                    label: {
                                            playerBox(batter)
                                                .padding(.vertical, 1)
                                        }
                                    }

                                    if let pitcher = pitchersAndBatters.safeGet(at: playerInd) as? ParsedPitcher {
                                        playerBox(pitcher)
                                            .padding(.vertical, 1)
                                    }
                                }
                            }

                            Button("Load more") {
                                playerLimit += 20
                                Task {
                                    await updatePlayers()
                                }
                            }
                        }
                    }.padding()
                }

                // MARK: - Start of main modifiers

                .onAppear {
                    if pitchersAndBatters.isEmpty { showSpinning = true }
                    model.resetDraft()
                    Task {
                        await updatePlayers()
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Round \(model.draft.roundNumber)")
                .sheet(isPresented: $showMyTeamQuickView) {
                    NVMyTeamQuickView()
                        .putInNavView(displayMode: .inline)
                }
                .alert("Draft is over", isPresented: $model.draft.shouldEnd) {
                    Button("OK") {
                    }
                }
                .navigationDestination(for: ParsedBatter.self) { batter in
                    NVDraftPlayerDetail(batter: batter)
                }
                .confirmationDialog(draftConfirmationMessage, isPresented: $showDraftConfirmation, titleVisibility: .visible) {
                    Button("Draft", role: .destructive) {
                        guard let playerToDraft = playerToDraft else { return }
                        model.draft.makePick(playerToDraft)
                        self.playerToDraft = nil
                    }
                    Button("Cancel", role: .cancel) {
                        playerToDraft = nil
                        showDraftConfirmation = false
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Menu {
                            Button {
                                model.draft.undoPick()
                            } label: {
                                HStack {
                                    Image(systemName: "arrow.uturn.backward")
                                    Text("Undo last pick")
                                }
                            }

                            Button(role: .destructive) {
                                model.resetDraft()
                            } label: {
                                Label("Restart draft", systemImage: "restart")
                            }

                        } label: {
                            Label("Menu", systemImage: "line.3.horizontal")
                        }
                    }
                }
                .blur(radius: lm.shouldShow ? 3 : 0)
                .overlay {
                    if lm.shouldShow {
                        LoadingScreen()
                    }
                }
            }
        }
    }
}

// MARK: - NVDraft_Previews

struct NVDraft_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            NVDraft()
                .environmentObject(MainModel.shared)
                .environmentObject(LoadingManager.shared)
        }

//            .putInNavView(displayMode: .inline)
    }
}
