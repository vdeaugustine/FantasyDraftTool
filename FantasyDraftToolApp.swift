//
//  FantasyDraftToolApp.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/11/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()


    return true
  }
}


@main
struct FantasyDraftToolApp: App {
    @StateObject private var model: MainModel = MainModel.shared
    @StateObject private var loadingManager: LoadingManager = LoadingManager.shared
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .environmentObject(loadingManager)
                .toolbarColorScheme(.dark, for: .navigationBar)
                
        }
    }
}
