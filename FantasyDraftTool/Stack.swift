//
//  Stack.swift
//  FantasyDraftTool
//
//  Created by Vincent DeAugustine on 1/31/23.
//

import Foundation

// MARK: - Stack

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
