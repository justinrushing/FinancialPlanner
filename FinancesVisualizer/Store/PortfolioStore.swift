//
//  PortfolioStore.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/1/23.
//

import Foundation

protocol PortfolioDataSource {
    func load(path: String, metadata: PortfolioMetadataStore) throws -> PortfolioHistory
}

final class PortfolioStore: ObservableObject {
    static let shared = PortfolioStore(dataSource: FidelityDataSource())

    private let dataSource: PortfolioDataSource

    @Published
    var history: PortfolioHistory = .init(records: [])

    init(dataSource: PortfolioDataSource) {
        self.dataSource = dataSource
    }

    func loadHistory(path: String) {
        do {
            self.history = try dataSource.load(path: path, metadata: PortfolioMetadataStore.shared)
        } catch {
            print("Error fetching history: \(error)")
        }
    }
}

// MARK: - Fidelity

final class FidelityDataSource: PortfolioDataSource {
    func load(path: String, metadata: PortfolioMetadataStore) throws -> PortfolioHistory {
        let fidelitySnapshots = try FidelityPortfolioParser().parseDirectory(path: path)
        let records: [PortfolioRecord] = fidelitySnapshots.flatMap { snapshot in
            snapshot.records.map {
                .init(
                    account: metadata.account(id: $0.accountNumber),
                    holding: metadata.holding(symbol: $0.symbol),
                    date: snapshot.date,
                    currentValue: $0.currentValue
                )
            }
        }.filter { $0.holding != .unknown(symbol: "Pending Activity") } // No reason to include these

        return .init(records: records)
    }
}
