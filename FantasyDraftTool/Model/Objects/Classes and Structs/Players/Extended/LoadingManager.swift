//
//  LoadingManager.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 3/3/23.
//

import Foundation

class LoadingManager: ObservableObject {
    
    @Published var shouldShow: Bool = true
    @Published var displayString: String = "Loading... "
    @Published var taskPercentage: Double = 0
    
    static var shared: LoadingManager = LoadingManager()
    
    func doTask(task: @escaping ()->()) async {
        Task {
            task()
        }
    }
    
    func changeDisplayString(_ newString: String) {
        
            DispatchQueue.main.async { [weak self] in
                self?.displayString = newString
            }
        
    }
    func changePercentage(_ new: Double) {
        
            DispatchQueue.main.async {[weak self] in
                self?.taskPercentage = new
            }
        
    }
    
}
