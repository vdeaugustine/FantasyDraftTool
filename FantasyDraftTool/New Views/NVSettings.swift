//
//  NVSettings.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 2/22/23.
//

import SwiftUI

// MARK: - MainSettings

struct MainSettings: Codable, Hashable {
    var defaultProjection: ProjectionTypes = .steamer

    enum CodingKeys: CodingKey {
        case defaultProjection
    }

    init() {}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.defaultProjection = try values.decode(ProjectionTypes.self, forKey: .defaultProjection)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(defaultProjection, forKey: .defaultProjection)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(defaultProjection)
    }
}

// MARK: - NVSettings

struct NVSettings: View {
    @EnvironmentObject private var model: MainModel
    @State private var positionLimit = UserDefaults.positionLimit

    var body: some View {
        List {
            Section("Limits") {
                Picker("Outfield Limit", selection: $positionLimit) {
                    ForEach(50 ... 250, id: \.self) { num in
                        if num.isMultiple(of: 5) {
                            Text("\(num)")
                                .tag(num)
                        }
                    }
                }
                .onChange(of: positionLimit) { newVal in

                    UserDefaults.positionLimit = newVal
                }

                NavigationLink {
                    NVDownloadBatters()
                } label: {
                    Text("Download")
                }
            }

            Section {
                NavigationLink {
                    DefaultProjectionView(defaultProjection: model.mainSettings.defaultProjection)
                } label: {
                    Text("Defaults Projection")
                        .spacedOut(text: model.mainSettings.defaultProjection.title)
                }
            }
        }
    }
}

// MARK: - DefaultProjectionView

struct DefaultProjectionView: View {
    @State var defaultProjection: ProjectionTypes
    @EnvironmentObject private var model: MainModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section {
                Picker("Default Projection", selection: $defaultProjection) {
                    ForEach(ProjectionTypes.batterArr, id: \.self) { projection in
                        Text(projection.title)
                            .tag(projection)
                    }
                }
            } header: {
            } footer: {
                Text("You can select a projection type for each player, and edit individual stat values as needed. The chosen projection type will serve as the default value for each stat, which can then be customized as per your requirements.")
            }
        }
        .toolbarSave {
            model.mainSettings.defaultProjection = defaultProjection
            model.save()
            dismiss()
        }
        .onAppear {
            defaultProjection = model.mainSettings.defaultProjection
        }
    }
}

// MARK: - NVSettings_Previews

struct NVSettings_Previews: PreviewProvider {
    static var previews: some View {
        NVSettings()
            .environmentObject(MainModel.shared)
            .putInNavView()
    }
}
