//
//  Stack.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/31/23.
//

import Foundation

// MARK: - Stack

struct Stack<T>: Codable, Equatable, Hashable where T : Codable, T: Hashable, T: Equatable  {
    
    static func == (lhs: Stack<T>, rhs: Stack<T>) -> Bool {
        lhs.array == rhs.array
    }
    
    private var array: [T] = []
    
    func getArray() -> [T] {
        array
    }

    mutating func push(_ element: T) {
        array.insert(element, at: 0)
        
    }

    /// Oldest item. item on the bottom
    mutating func popLast() -> T? {
        return array.popLast()
    }
    
    /// Most recent item
    mutating func popFirst() -> T? {
        return array.removeFirst()
    }

    func peek() -> T? {
        return array.last
    }

    func isEmpty() -> Bool {
        return array.isEmpty
    }
    
    func top() -> T? {
        array.first
    }
}
