//
//  Dictionary+Utilities.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/1/23.
//

import Foundation

extension Sequence {
    public func dictionary<T: Hashable>(keyedBy: (Element) -> T) -> [T: Element] {
        // Last write wins
        dictionary(keyedBy: keyedBy, resolver: { _, value in value })
    }

    public func dictionary<T: Hashable>(keyedBy: (Element) -> T, resolver: (Element?, Element) -> Element) -> [T: Element] {
        self.reduce(into: [:]) {
            let key = keyedBy($1)
            $0[key] = resolver($0[key], $1)
        }
    }

    public func organized<T: Hashable>(by: (Element) -> T) -> [T: [Element]] {
        self.reduce(into: [:]) { $0[by($1), default: []].append($1) }
    }
}
