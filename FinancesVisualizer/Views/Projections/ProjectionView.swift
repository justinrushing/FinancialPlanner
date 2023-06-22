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
    var projections: [ProjectedValue]

    var body: some View {
        Chart {
            ForEach(projections) { point in
                BarMark(
                    x: .value("Date", point.date),
                    y: .value("Current Value", point.value)
                )
            }
        }
    }
    
    private struct DataPoint: Identifiable {
        var id: Date { date }
        let date: Date
        let value: Double
    }
}
