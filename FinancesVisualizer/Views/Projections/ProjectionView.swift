//
//  ProjectionView.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/21/23.
//

import Charts
import Foundation
import SwiftUI

struct ProjectionView: View {
    var label: String
    var projections: [ProjectedValue]
    @State private var hoverDate: Date?

    var body: some View {
        VStack {
            Text(label)

            Chart {
                ForEach(projections) { point in
                    BarMark(
                        x: .value("Date", point.date),
                        y: .value("Current Value", point.value)
                    )
                }

                if let hoverDate, let point = projections.first(where: { $0.sameYearAs(date: hoverDate) }) {
                    RectangleMark(x: .value("Date", point.date))
                        .foregroundStyle(.primary.opacity(0.2))
                        .annotation(position: moreThanHalfWay(date: point.date) ? .leading : .trailing) {
                            VStack {
                                AnnotationView(value: point)
                                    .frame(maxHeight: 100)
                            }
                        }
                }

            }
            .chartYAxis {
                AxisMarks(format: .currency(code: "USD"))
            }
            .chartOverlay { (chartProxy: ChartProxy) in
                return Color.clear
                    .onContinuousHover { hoverPhase in
                        switch hoverPhase {
                        case .active(let hoverLocation):
                            hoverDate = chartProxy.value(
                                atX: hoverLocation.x, as: Date.self
                            )
                        case .ended:
                            hoverDate = nil
                        }
                    }
            }
        }
    }

    private func moreThanHalfWay(date: Date) -> Bool {
        guard let min = projections.first?.date, let max = projections.last?.date else { return false }
        let mid = (min.timeIntervalSinceReferenceDate + max.timeIntervalSinceReferenceDate) / 2.0
        return date.timeIntervalSinceReferenceDate >= mid
    }

    private struct DataPoint: Identifiable {
        var id: Date { date }
        let date: Date
        let value: Double
    }
}

private struct AnnotationView: View {
    static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .none
        return f
    }()

    var value: ProjectedValue

    var body: some View {
        VStack(alignment: .leading) {
            Text("Year: \(value.year)")
                .font(.headline)

            Text("Value: \(value.value)")
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}
