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

    // MARK: - Allocations

    var allocationsSelectedBreakdown: AllocationsTab.BreakdownType {
        get {
            if let stringValue: String = read() {
                return .init(rawValue: stringValue) ?? .defaultValue
            }
            return .defaultValue
        }
        set { write(value: newValue.rawValue) }
    }

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

    var filterCash: Bool {
        get { read() }
        set { write(value: newValue) }
    }

    var projectedSocialSecurityIncome: Double {
        get { read() }
        set { write(value: newValue) }
    }

    var socialSecurityCollectionYear: Int {
        get { read() }
        set { write(value: newValue) }
    }

    // MARK: - Taxes

    var income: Double {
        get { read() }
        set { write(value: newValue) }
    }

    var pretaxDeduction: Double {
        get { read() }
        set { write(value: newValue) }
    }

    var taxRate: TaxRateDescriptor {
        get { readCodable() ?? .defaultRate }
        set { writeCodable(value: newValue) }
    }

    // MARK: - Helpers

    private func write(value: Any?, key: String = #function) {
        defaults.set(value, forKey: key)
        self.objectWillChange.send()
    }

    private func writeCodable<T: Codable>(value: T?, key: String = #function) {
        let encoder = JSONEncoder()
        let data = try? encoder.encode(value)
        write(value: data, key: key)
    }

    private func read(key: String = #function) -> Double {
        defaults.double(forKey: key)
    }

    private func read(key: String = #function) -> Bool {
        defaults.bool(forKey: key)
    }

    private func read(key: String = #function) -> Int {
        defaults.integer(forKey: key)
    }

    private func read(key: String = #function) -> String? {
        defaults.string(forKey: key)
    }

    private func readCodable<T: Codable>(key: String = #function) -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}
