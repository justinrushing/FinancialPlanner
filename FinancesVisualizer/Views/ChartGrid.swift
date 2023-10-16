//
//  ContentView.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/1/23.
//

import SwiftUI
import Charts

struct ChartGrid: View {
    enum ChartType {
        case area
        case line
    }

    @State private var hoverDate: Date?
    private let history: PortfolioHistory
    private let query: ChartingQuery
    private let type: ChartType

    init(history: PortfolioHistory, query: ChartingQuery, type: ChartType = .area) {
        self.history = history
        self.query = query
        self.type = type
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
        let selectedDate = from.closestDate(to: hoverDate)
        return VStack {
            Text(from.name)
                .font(.headline)

            Chart {
                ForEach(from.series) { series in
                    ForEach(series.points) { point in
                        switch type {
                        case .area:
                            AreaMark(
                                x: .value("Date", point.date),
                                y: .value("Current Value", Double(point.value))
                            )
                            .foregroundStyle(by: .value("id", series.label))
                        case .line:
                            LineMark(
                                x: .value("Date", point.date),
                                y: .value("Current Value", Double(point.value))
                            )
                            .foregroundStyle(by: .value("id", series.label))
                        }

                    }
                }

                if let selectedDate {
                    RectangleMark(x: .value("Date", selectedDate))
                        .foregroundStyle(.primary.opacity(0.2))
                        .annotation(position: moreThanHalfWay(date: selectedDate, chart: from) ? .leading : .trailing) {
                            AnnotationView(summary: from.summary(date: selectedDate))
                        }
                }
            }
            .chartOverlay { (chartProxy: ChartProxy) in
                return Color.clear
                    .onContinuousHover { hoverPhase in
                        switch hoverPhase {
                        case .active(let hoverLocation):
                            hoverDate = chartProxy.value(
                                atX: hoverLocation.x, as: Date.self
                            ).flatMap { min($0, .now) }
                        case .ended:
                            hoverDate = nil
                        }
                    }
            }
        }
    }

    private func moreThanHalfWay(date: Date, chart: ChartingQuery.Chart) -> Bool {
        guard let min = chart.minDate, let max = chart.maxDate else { return false }
        let mid = (min.timeIntervalSinceReferenceDate + max.timeIntervalSinceReferenceDate) / 2.0
        return date.timeIntervalSinceReferenceDate >= mid
    }
}

private struct AnnotationView: View {
    static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        return f
    }()

    var summary: ChartingQuery.Chart.Summary

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Total: \(summary.total)")
                    .font(.headline)
                Spacer()
                Text(Self.dateFormatter.string(from: summary.date))
            }

            Divider()

            ForEach(Array(summary.values.keys).sorted(), id: \.self) { key in
                Text("\(key): \(summary.values[key] ?? 0)")
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}
