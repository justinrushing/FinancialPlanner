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
                TabView {
                    AllocationsTab()
                        .tabItem { Text("Allocations") }

                    ProjectionTab()
                        .tabItem { Text("Projections") }
                }
                .padding()
            }
            .onAppear {
                store.loadHistory(path: "/Users/jrush/Library/Mobile Documents/com~apple~CloudDocs/Fidelity History")
            }
        }
    }
}
