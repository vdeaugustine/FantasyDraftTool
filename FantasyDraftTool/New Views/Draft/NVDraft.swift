//
//  NVDraft.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/14/23.
//

import SwiftUI

// MARK: - NVDraft

struct NVDraft: View {
    @EnvironmentObject private var model: MainModel
    @State private var projection: ProjectionTypes = .atc
    @State private var sortOptionSelected: NVSortByDropDown.Options = .score {
        didSet {
            updatePlayers()
        }
    }
    @State private var positionSelected: Position? = nil
    @State private var showMyTeamQuickView = false
    @State private var showPlayerSheet = false
    @State private var batterForDetail: ParsedBatter? = nil
    @State private var numPicksToSim: Int = 50
    @State private var draftProgress: Double = -1
    @State private var loadingDone: Bool = true
    @State private var showDraftConfirmation = false
    @State private var batterToDraft: ParsedBatter? = nil
    @State private var showMenu: Bool = false
    @State private var playerLimit: Int = 20
    @State private var pitchersAndBatters: [any ParsedPlayer] = []
    @State private var showSpinning = true
    
    func updatePlayers() {
        
        Task {
            print("Updating")
            
            let presorted = await model.draft.playerPool.allStoredPlayers(projection: projection, scoring: model.draft.settings.scoringSystem, batterLimit: playerLimit, pitcherLimit: playerLimit, sort: false)
            pitchersAndBatters = await sortedPlayers(presorted)
            showSpinning = false
        }
        

    }

    var filteredPlayers: [ParsedBatter] {
        // TODO: When switching
//        loadingDone = false
        if let positionSelected = positionSelected {
            return model.draft.playerPool.batters(for: [positionSelected], projection: projection, draft: model.draft)
        }

        return model.draft.playerPool.batters(for: Position.batters, projection: projection)
    }

//    var pitchersAndBatters: [any ParsedPlayer] {
//        let filtered = filteredPlayers
//        let pitchers = model.draft.playerPool.storedPitchers.pitchers(for: projection)
//        let before = model.draft.playerPool.allStoredPlayers(projection: projection)
//        let sorted = before.sorted(by: {$0.zScore(draft: model.draft) > $1.zScore(draft: model.draft)})
//
//        return sorted
//
//    }

    func sortedPlayers(_ presorted: [any ParsedPlayer]) async -> [any ParsedPlayer] {
        let retArr: [any ParsedPlayer]
        switch sortOptionSelected {
        case .points:
            retArr =  presorted.sorted { $0.fantasyPoints(model.scoringSettings) > $1.fantasyPoints(model.scoringSettings) }
        case .score:
            retArr =  presorted.sorted { $0.zScore(draft: model.draft) > $1.zScore(draft: model.draft) }
        default:
            return presorted
        }
//            case .hr:
//                retArr = await presorted.sorted { $0.hr > $1.hr }
//            case .rbi:
//                retArr = await presorted.sorted { $0.rbi > $1.rbi }
//            case .r:
//                retArr = await presorted.sorted { $0.r > $1.r }
//            case .sb:
//                retArr = await presorted.sorted { $0.sb > $1.sb }
        

        
        return retArr
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
        if let batter = batterToDraft {
            return "Draft \(batter.name) for \(model.draft.currentTeam.name)?"
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
                    model.draft.addOrRemoveStar(player)
                } label: {
                    Image(systemName: model.draft.isStar(player) ? "heart.fill" : "heart")
                        .foregroundColor(model.draft.isStar(player) ? Color.red : Color.black)
                        .font(.subheadline)
                }
                Button {
                    showDraftConfirmation.toggle()
                } label: {
                    Image(systemName: "checklist")

                        .font(.subheadline)
                }
            }.frame(maxHeight: .infinity)
            NVAllPlayersRow(player: player)
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
                        NVPicksSection()

                        VStack(alignment: .leading) {
                            Text("Filled")
                            HStack {
                                ForEach(Position.batters, id: \.self) { pos in

                                    LabelAndValueRect(label: pos.str.uppercased(), value: myTeam.players(for: pos).count.str, color: .white)
                                }
                            }
                            .height(60)
                        }

                        HStack {
                            NVDropDownProjection(selection: $projection)
                            NVSortByDropDown(selection: $sortOptionSelected)
                                .onChange(of: sortOptionSelected) { _ in
                                    updatePlayers()
                                }
                            NVDropDownPosition(selection: $positionSelected)
                        }.pushLeft().padding(.top)

                        if let recommended = myTeam.recommendedPlayer(draft: model.draft, projection: projection) {
                            VStack(alignment: .leading) {
                                Text("Recommended")
                                playerBox(recommended)
                            }
                        }

                        // MARK: - Available Players

                        VStack(alignment: .leading) {
                            Text("Available")
                            if showSpinning {
                                ProgressView()
                            }
                            LazyVStack {
                                ForEach(pitchersAndBatters.indices, id: \.self) { playerInd in

                                    if let batter = pitchersAndBatters.safeGet(at: playerInd) as? ParsedBatter {
                                        playerBox(batter)
                                            .padding(.vertical, 1)
                                    }

                                    if let pitcher = pitchersAndBatters.safeGet(at: playerInd) as? ParsedPitcher {
                                        playerBox(pitcher)
                                            .padding(.vertical, 1)
                                    }

//                                    if let pitcher = pitchersAndBatters.safeGet(at: playerInd) as? ParsedPitcher {
//
//                                    }

//                                    if let batter = pitchersAndBatters.safeGet(at: playerInd) as? ParsedBatter {
//
//                                    }

//                                    Button {
//                                        model.navPathForDrafting.append(batter)
//                                    } label: {
//                                        playerBox(batter)
//                                            .padding(.vertical, 1)
//                                    }
//                                    .buttonStyle(.plain)
                                }
                            }
                            
                            Button("Load more") {
                                playerLimit += 20
                                updatePlayers()
                            }
                        }
                    }.padding()
                }

                // MARK: - Start of main modifiers

                .onAppear {
                    if pitchersAndBatters.isEmpty { showSpinning = true }

                    updatePlayers()
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
                        guard let batterToDraft = batterToDraft else { return }
                        model.draft.makePick(batterToDraft)
                        self.batterToDraft = nil
                    }
                    Button("Cancel", role: .cancel) {
                        batterToDraft = nil
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
            }
        }
    }
}

// MARK: - NVDraft_Previews

struct NVDraft_Previews: PreviewProvider {
    static var previews: some View {
        NVDraft()
            .environmentObject(MainModel.shared)
            .putInNavView(displayMode: .inline)
    }
}
