//
//  ContentView.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var projection: ProjectionTypes = .steamer
    
    var data: [ParsedBatter] {
        switch projection {
        case .steamer:
            return AllParsedBatters.steamer.all
        case .zips:
            return AllParsedBatters.steamer.all
        case .thebat:
            return AllParsedBatters.theBat.all
        case .thebatx:
            return AllParsedBatters.theBatx.all
        case .atc:
            return AllParsedBatters.atc.all
        case .depthCharts:
            return AllParsedBatters.depthCharts.all
        }
    }
    
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
                ForEach(data, id: \.self) { datum in
                    Text(datum.name)
                        .spacedOut(text: datum.hr.str)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
