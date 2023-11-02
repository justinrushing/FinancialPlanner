//
//  AllocationsTab.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/21/23.
//

import Foundation
import SwiftUI

struct AllocationsTab: View {
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

            ChartGrid(
                history: filteredHistory,
                query: .init(
                    reducer: .sum,
                    property: \.currentValue,
                    split: \.holding.category.categoryDescription
//                    grid: \.account.accountName
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
                    split: \.holding.category.categoryDescription
                ),
                type: .line
            )
            .frame(height: 300)


            Text("All")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: filteredHistory.latestSnapshot,
                keypath: \.holding.category.subcategoryDescription
            )

            Text("Non-Retirement Accounts")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: filteredHistory
                    .filter { !$0.account.retirementAccount }
                    .latestSnapshot,
                keypath: \.holding.category.subcategoryDescription
            )

            Text("Retirement Accounts")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: filteredHistory.filter { $0.account.retirementAccount }.latestSnapshot,
                keypath: \.holding.category.subcategoryDescription
            )
        }
    }
}
