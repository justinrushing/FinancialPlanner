//
//  FinancesVisualizerApp.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/1/23.
//

import SwiftUI

@main
struct FinancesVisualizerApp: App {
    @ObservedObject var store = PortfolioStore.shared

    var body: some Scene {
        WindowGroup {
            ScrollView {
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
                .padding()
            }
            .onAppear {
                store.loadHistory(path: "/Users/jrush/Library/Mobile Documents/com~apple~CloudDocs/Fidelity History")
            }
        }
    }
}
