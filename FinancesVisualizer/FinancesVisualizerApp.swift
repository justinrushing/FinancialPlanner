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
                VStack {
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
                        keypath: \.holding.category.categoryDescription
                    )

                    Text("Non-Retirement Accounts")
                        .font(.title)
                    PortfolioSnapshotView(
                        snapshot: store.history.filter { !$0.account.retirementAccount }.latestSnapshot,
                        keypath: \.holding.category.categoryDescription
                    )

                    Text("Retirement Accounts")
                        .font(.title)
                    PortfolioSnapshotView(
                        snapshot: store.history.filter { $0.account.retirementAccount }.latestSnapshot,
                        keypath: \.holding.symbol
                    )
                }
            }
            .onAppear {
                store.loadHistory(path: "/Users/jrush/Library/Mobile Documents/com~apple~CloudDocs/Fidelity History")
            }
        }
    }
}
