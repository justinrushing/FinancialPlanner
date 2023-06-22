//
//  CurrentValueView.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/12/23.
//

import Foundation
import SwiftUI

struct PortfolioSnapshotView: View {
    let snapshot: PortfolioSnapshot
    let keypath: KeyPath<PortfolioRecord, String>

    static let percentFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.percentSymbol = "%"
        f.numberStyle = .percent
        return f
    }()

    static let dollarFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.currencySymbol = "$"
        f.numberStyle = .currency
        return f
    }()


    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                let totalValueString = Self.dollarFormatter.string(from: NSNumber(value: snapshot.totalValue)) ?? ""

                Text("Total Value: \(totalValueString)")
                    .font(.headline)

                let records = snapshot
                    .records
                    .organized { $0[keyPath: keypath] }
                    .mapValues { $0.map(\.currentValue).reduce(0, +) }
                    .enumerated()
                    .sorted { $0.element.value > $1.element.value }

                ForEach(Array(records), id: \.offset) { key, value in
                    let percent = value.value / snapshot.totalValue
                    let percentString = Self.percentFormatter.string(from: NSNumber(value: percent)) ?? ""
                    let dollarString = Self.dollarFormatter.string(from: NSNumber(value: value.value)) ?? ""

                    Text("\(value.key): \(dollarString) / \(percentString)")
                }
            }
            Spacer()
        }

    }
}
