//
//  DVHomeLeaguesRect.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI

// MARK: - DVHomeLeaguesRect

struct DVHomeLeaguesRect: View {
    @EnvironmentObject private var model: MainModel
    @Binding var showConfirmation: Bool
    @Binding var draftSelected: Draft?

    var results: [DraftResults] {
        DraftResults.loadResultsArray()
    }

    var rectHeight: CGFloat {
        if results.isEmpty {
            return 150
        }
        return 300
    }

    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 16) {
                    Image(systemName: "list.bullet.clipboard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 33, height: 50)
                        .foregroundStyle(.white, .cyan, .cyan)

                    Text("Leagues")
                        .font(size: 18, color: .white, weight: .semibold)
                }
                Spacer()

                Button {
                    model.navPathForDrafting.append(DraftDestination.setupDraft)
                } label: {
                    Label("Create New", systemImage: "plus")
                        .background(color: MainModel.shared.specificColor.nice, padding: 10)
                }
                .buttonStyle(.plain)
            }

            List {
                if results.isEmpty {
                    Text("No drafts completed yet")
                        .font(size: 14, color: .white, weight: .semibold)
                        .listRowBackground(MainModel.shared.specificColor.rect)
                } else {
                    ForEach(results) { result in
                        NavigationLink {
                            DraftResultsView(draftResults: result)
                        } label: {
                            VStack(alignment: .leading, spacing: 7) {
                                Text(result.leagueName)
                                    .font(size: 14, color: .white, weight: .semibold)
                                Text(result.dateCompleted.getFormattedDate(format: .abreviatedMonth))
                                    .font(size: 12, color: .white, weight: .light)
                                Text([result.teams.count.str, "teams"])
                                    .font(size: 12, color: .white, weight: .light)
                            }
                            .allPartsTappable(alignment: .leading)

                            .listRowBackground(MainModel.shared.specificColor.rect)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .height(rectHeight)
        .navigationDestination(for: DraftDestination.self) { draftDestination in
            switch draftDestination {
                case .loadDraft:
                    DVDraft()
                case .newDraft:
                    DVDraft()
                case .setupDraft:
                    DVSetUpLeagueView()
            }
        }
    }
}

// MARK: - DVHomeLeaguesRect_Previews

struct DVHomeLeaguesRect_Previews: PreviewProvider {
    static var previews: some View {
        DVHomeLeaguesRect(showConfirmation: .constant(false), draftSelected: .constant(nil))
            .environmentObject(MainModel.shared)
    }
}
