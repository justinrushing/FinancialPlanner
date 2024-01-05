//
//  AllocationsTab.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/21/23.
//

import Foundation
import SwiftUI

struct AllocationsTab: View {
    enum BreakdownType: String, CaseIterable, Identifiable {
        var id: String { rawValue }
        static var defaultValue: Self = .category

        case category = "Category"
        case subcategory = "Subcategory"

        var split: KeyPath<PortfolioRecord, String> {
            switch self {
            case .category: return \.holding.category.categoryDescription
            case .subcategory: return \.holding.category.subcategoryDescription
            }
        }
    }

    @ObservedObject var config = ConfigurationStore.shared
    @ObservedObject var store = PortfolioStore.shared

    private var filteredHistory: PortfolioHistory {
        let history = store.history

        if config.filterCash {
            return history.filter { $0.holding.category != .cash }
        }

        return history
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Toggle(isOn: $config.filterCash) { Text("Filter out cash") }
            Picker("Breakdown", selection: $config.allocationsSelectedBreakdown) {
                ForEach(BreakdownType.allCases) { descriptor in
                    Text(descriptor.rawValue).tag(descriptor)
                }
            }

            ChartGrid(
                history: filteredHistory,
                query: .init(
                    reducer: .sum,
                    property: \.currentValue,
                    split: config.allocationsSelectedBreakdown.split
                ),
                type: .area
            )
            .frame(height: 300)
            
            ChartGrid(
                history: filteredHistory,
                query: .init(
                    reducer: .sum,
                    property: \.currentValue,
                    split: \.holding.category.categoryDescription
                ),
                type: .line
            )
            .frame(height: 300)

            ChartGrid(
                history: filteredHistory,
                query: .init(
                    reducer: .percent,
                    property: \.currentValue,
                    split: config.allocationsSelectedBreakdown.split
                ),
                type: .line
            )
            .frame(height: 300)


            Text("All")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: filteredHistory.latestSnapshot,
                keypath: config.allocationsSelectedBreakdown.split
            )

            Text("Non-Retirement Accounts")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: filteredHistory
                    .filter { !$0.account.retirementAccount }
                    .latestSnapshot,
                keypath: config.allocationsSelectedBreakdown.split
            )

            Text("Retirement Accounts")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: filteredHistory.filter { $0.account.retirementAccount }.latestSnapshot,
                keypath: config.allocationsSelectedBreakdown.split
            )
        }
    }
}
