//
//  AllocationsTab.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/21/23.
//

import Foundation
import SwiftUI

struct AllocationsTab: View {
    @ObservedObject var store = PortfolioStore.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ChartGrid(
                history: store.history,
                query: .init(
                    reducer: .sum,
                    property: \.currentValue,
                    split: \.holding.category.subcategoryDescription
//                    grid: \.account.accountName
                )
            )

            Text("All")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: store.history.latestSnapshot,
                keypath: \.holding.category.subcategoryDescription
            )

            Text("Non-Retirement Accounts")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: store.history.filter { !$0.account.retirementAccount }.latestSnapshot,
                keypath: \.holding.category.subcategoryDescription
            )

            Text("Retirement Accounts")
                .font(.title)
            PortfolioSnapshotView(
                snapshot: store.history.filter { $0.account.retirementAccount }.latestSnapshot,
                keypath: \.holding.category.subcategoryDescription
            )
        }
    }
}
