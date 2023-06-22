//
//  ConfigurationStore.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/21/23.
//

import Foundation

final class ConfigurationStore: ObservableObject {
    static let shared = ConfigurationStore()

    private let defaults = UserDefaults.standard

    // MARK: - Synthesized Properties

    var compoundRate: Double {
        get { read() }
        set { write(value: newValue) }
    }

    var retirementYear: Int {
        get { read() }
        set { write(value: newValue) }
    }

    var targetSpending: Double {
        get { read() }
        set { write(value: newValue) }
    }

    var inflationRate: Double {
        get { read() }
        set { write(value: newValue) }
    }

    var yearlyContribution: Double {
        get { read() }
        set { write(value: newValue) }
    }

    // MARK: - Helpers

    private func write(value: Any?, key: String = #function) {
        defaults.set(value, forKey: key)
        self.objectWillChange.send()
    }

    private func read(key: String = #function) -> Double {
        defaults.double(forKey: key)
    }

    private func read(key: String = #function) -> Int {
        defaults.integer(forKey: key)
    }
}
