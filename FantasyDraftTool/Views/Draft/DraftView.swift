//
//  DraftView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/28/23.
//

import SwiftUI

struct Stack<T> {
    var array: [T] = []
    
    mutating func push(_ element: T) {
        array.insert(element, at: 0)
    }
    
    mutating func pop() -> T? {
        return array.popLast()
    }
    
    func peek() -> T? {
        return array.last
    }
    
    func isEmpty() -> Bool {
        return array.isEmpty
    }
}


// MARK: - DraftView

struct DraftView: View {
    let draft: Draft
    @State private var currentTeam: DraftTeam = DraftTeam(name: "", draftPosition: 1)
    @State private var totalPickNumber: Int = 1
    @State private var pickStack: Stack<DraftPlayer> = .init()

    var roundNumber: Int {
        (totalPickNumber - 1) / draft.settings.numberOfTeams + 1
    }

    var roundPickNumber: Int {
        (totalPickNumber - 1) % draft.settings.numberOfTeams + 1
    }
    
    @State private var playerPool = AllParsedBatters.batters(for: .steamer)

    var body: some View {
        List {
            Text("Current team: \(currentTeam.name)")
            Text("Round \(roundNumber), Pick \(roundPickNumber)")
            
            
            Section("Recent picks") {
                ScrollView(.horizontal){
                    LazyHStack {
                        ForEach(pickStack.array, id: \.self) { pick in
                            Text("\(pick.team.name): \(pick.player.name),")
                        }
                    }
                }
                NavigationLink("Show all") {
                    DraftSummaryView(players: pickStack, draft: draft)
                }
            }
            
            
            
            Section {
                ForEach(playerPool, id: \.self) { batter in
                    Button {
                        makePick(player: batter)
                    } label: {
                        Text(batter.name)
                    }
                    
                }
            }
            
            
        }
        .onAppear {
            currentTeam = draft.teams.first!
        }
    }

    func makePick(player: ParsedBatter) {
        
        playerPool.removeAll(where: {$0 == player})
        let draftPlayer = DraftPlayer(player: player, pickNumber: totalPickNumber, team: currentTeam)
        pickStack.push(draftPlayer)
        totalPickNumber += 1
        setNextTeam()
        
    }
    
    func setNextTeam() {
        let numberOfTeams = draft.settings.numberOfTeams
        
        let currentTeamIndex: Int = roundNumber.isEven ? numberOfTeams - roundPickNumber : roundPickNumber - 1
        currentTeam = draft.teams[currentTeamIndex]
    }
}

// MARK: - DraftView_Previews

struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView(draft: .init(teams: (0 ..< 10).map {
            DraftTeam(name: "Team \($0 + 1)",
                      draftPosition: $0)
        }, currentPickNumber: 1, settings: .init(numberOfTeams: 10,
                                                 snakeDraft: true,
                                                 numberOfRounds: 25,
                                                 scoringSystem: .defaultPoints))
        )
        .putInNavView()
    }
}
