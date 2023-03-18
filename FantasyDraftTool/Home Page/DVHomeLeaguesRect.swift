//
//  DVHomeLeaguesRect.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/16/23.
//

import SwiftUI

struct DVHomeLeaguesRect: View {
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
                    
                } label: {
                    Label("Create New", systemImage: "plus")
                        .background(color: MainModel.shared.specificColor.nice, padding: 10)
                }
                .buttonStyle(.plain)
            }
            
            List {
                VStack(alignment: .leading, spacing: 7) {
                    Text("League Name")
                        .font(size: 14, color: .white, weight: .semibold)
                    Text("Draft Date: March 12, 2023")
                        .font(size: 12, color: .white, weight: .light)
                    Text("12 teams")
                        .font(size: 12, color: .white, weight: .light)
                }
                .listRowBackground(MainModel.shared.specificColor.rect)
            }
            .listStyle(.plain)
            
        }
        .height(300)
    }
}

struct DVHomeLeaguesRect_Previews: PreviewProvider {
    static var previews: some View {
        DVHomeLeaguesRect()
    }
}
