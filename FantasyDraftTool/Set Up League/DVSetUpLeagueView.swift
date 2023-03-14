//
//  DVSetUpLeagueView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/13/23.
//

import SwiftUI

// MARK: - DVSetUpLeagueView

struct DVSetUpLeagueView: View {
    @State private var teams: [DraftTeam] = DraftTeam.someDefaultTeams(amount: 8)
    @State private var myTeamIndex: Int = 0
    @State private var teamSelected: DraftTeam? = nil
    @State private var showAlert = false
    @State private var editedTeamName: String = ""
    @State private var editedTeamIndex: Int = 0
    @State private var scoring: ScoringSettings = .defaultPoints
    @State private var showScoringSheet = false
    @State private var showRosterSheet = false
    @State private var workingDraft = Draft.init(teams: DraftTeam.someDefaultTeams(amount: 8), settings: .defaultSettings)
    
    var listHeight: CGFloat {
        CGFloat(5 + (8 * 50))
    }

    var alertMessage: String {
        guard let teamSelected = teamSelected else {
            return "Problem team. Please hit cancel"
        }

        return "Edit name for \(teamSelected.name)"
    }

    var body: some View {
        VStack {
            Text("Set Up League")
                .font(size: 28, color: .white, weight: .bold)
                .pushLeft()

            VStack(spacing: 0) {
                List {
                    Section {
                        ForEach(teams.indices, id: \.self) { teamIndex in
                            if let team = teams.safeGet(at: teamIndex) {
                                Text(team.name)
                                    .allPartsTappable(alignment: .leading)
                                    .onTapGesture {
                                        editedTeamIndex = teamIndex
                                        teamSelected = team
                                        showAlert = true
                                    }
                            }
                        }
                        .onDelete { indexSet in
                            teams.remove(atOffsets: indexSet)
                        }
                        .onMove { indSet, theInt in
                            teams.move(fromOffsets: indSet, toOffset: theInt)
                        }
                        .listRowBackground(Color.niceGray)
                        .listRowSeparatorTint(Color.white)
                        
                        if teams.count < 15 {
                            Button {
                                teams.append(.init(name: "Team \(teams.count + 1)", draftPosition: teams.count))
                                
                            } label: {
                                Label("Add Team", systemImage: "plus")
                                
                                    .fontWeight(.semibold)
                            }
                            .listRowBackground(Color.niceGray)
                            .listRowSeparatorTint(Color.white)
                        }
                        
                        
                    } header: {
                        HStack {
                            Text("Teams")
                                .font(size: 16, color: .lighterGray, weight: .medium)

                            Spacer()

                            EditButton()
                                .font(size: 16, color: .white)
                        }
                    }

//                    if teams.count < 15 {
//                        Button {
//                            teams.append(.init(name: "Team \(teams.count + 1)", draftPosition: teams.count))
//
//                        } label: {
//                            Label("Add Team", systemImage: "plus")
//                                .fontWeight(.semibold)
//                        }
//
//                        .frame(maxWidth: .infinity)
//                        .buttonStyle(.plain)
//                        .layoutPriority(1)
//
//                        .listRowBackground(Color.clear)
//                        .background(color: .niceGray, padding: 10, shadow: 0)
//                    }

                    Section {
                        Picker("My Team", selection: $myTeamIndex) {
                            ForEach(teams.indices, id: \.self) { ind in

                                if let team = teams.safeGet(at: ind) {
                                    Text(team.name)
                                        .tag(ind)
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.niceGray)

                    Section {
                        Button {
                            showScoringSheet.toggle()
                        } label: {
                            Text(scoring.customOrDefault)
                                .spacedOut {
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.white)
                        }

                    } header: {
                        HStack {
                            Text("Scoring")
                                .font(size: 16, color: .lighterGray, weight: .medium)
                        }
                    }
                    .listRowBackground(Color.niceGray)
                    
                    Section {
                        
                        Button {
                            showRosterSheet.toggle()
                        } label: {
                            Text("Roster Settings")
                                .spacedOut {
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.white)
                        }
                        
                    } header: {
                        HStack {
                            Text("Rosters")
                                .font(size: 16, color: .lighterGray, weight: .medium)
                        }
                    }.listRowBackground(Color.niceGray)
                    
                    
                    Button {
                        

                    } label: {
                        Label("Go To Draft", systemImage: "play.fill")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                    
                    .frame(maxWidth: .infinity)
//                    .buttonStyle(.plain)
                    .layoutPriority(1)

                    .listRowBackground(Color.niceBlue)
//                    .background(color: .niceGray, padding: 10, shadow: 0)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.backgroundBlue.ignoresSafeArea()
        }
        .alert(alertMessage, isPresented: $showAlert) {
            TextField(teamSelected?.name ?? "", text: $editedTeamName)

            Button("Cancel", role: .cancel) {
            }
            Button("OK", role: .destructive) {
                guard let oldTeam = teamSelected else { return }
                oldTeam.name = editedTeamName
                teams[editedTeamIndex] = oldTeam
                teamSelected = nil
                editedTeamName = ""
            }
        }
        .sheet(isPresented: $showScoringSheet) {
            SetUpScoringView(scoringToSave: $scoring)
        }
        .sheet(isPresented: $showRosterSheet) {
            DVSetUpRosterStructureView(draft: $workingDraft)
        }
        
        
    }
}

// MARK: - DVSetUpLeagueView_Previews

struct DVSetUpLeagueView_Previews: PreviewProvider {
    static var previews: some View {
        DVSetUpLeagueView()
            .previewBackground()
            .putInNavView()
    }
}
