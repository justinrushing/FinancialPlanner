//
//  ContentView.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/1/23.
//

import SwiftUI
import Charts

struct ChartGrid: View {
    private let history: PortfolioHistory
    private let query: ChartingQuery

    init(history: PortfolioHistory, query: ChartingQuery) {
        self.history = history
        self.query = query
    }

    var body: some View {
        VStack {
            let charts = query.run(history: history)

            VStack {
                ForEach(charts) { chart in
                    makeChart(from: chart)
                }
            }
        }
    }

    private func makeChart(from: ChartingQuery.Chart) -> some View {
        VStack {
            Text(from.name)
                .font(.headline)

            Chart {
                ForEach(from.series) { series in
                    ForEach(series.points) { point in
                        AreaMark(
                            x: .value("Date", point.date),
                            y: .value("Current Value", Double(point.value))
                        )
                        .foregroundStyle(by: .value("id", series.label))
                    }
                }
            }
        }
    }
}
