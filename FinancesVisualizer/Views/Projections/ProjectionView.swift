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
            }
            .chartYAxis {
                AxisMarks(format: .currency(code: "USD"))
            }
        }
    }
    
    private struct DataPoint: Identifiable {
        var id: Date { date }
        let date: Date
        let value: Double
    }
}
