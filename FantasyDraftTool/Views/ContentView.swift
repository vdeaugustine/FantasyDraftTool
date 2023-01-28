//
//  ContentView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var projection: ProjectionTypes = .steamer
    
    
    var body: some View {
        VStack {
            Picker("Projection", selection: $projection) {
                ForEach(ProjectionTypes.arr, id: \.self) { proj in
                    Text(proj.title)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            List {
                ForEach(AllParsedBatters.batters(for: projection), id: \.self) { datum in
                    Text(datum.name)
                        .spacedOut(text: datum.fantasyPoints(.defaultPoints).str)
                }
            }
        }
        .background(Color.listBackground)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
