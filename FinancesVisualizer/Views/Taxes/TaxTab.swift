//
//  TaxTab.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 11/14/23.
//

import Foundation
import SwiftUI

struct TaxTab: View {
    @ObservedObject var configuration = ConfigurationStore.shared

    var body: some View {
        VStack {
            settings
        }
    }

    private var settings: some View {
        Form {
            TextField("Income", value: $configuration.income, formatter: decimalFormatter)
            TextField("Pre-Tax Deductions", value: $configuration.pretaxDeduction, formatter: decimalFormatter)
            Picker("Bracket", selection: $configuration.taxRate) {
                ForEach(TaxRateDescriptor.allCases) { descriptor in
                    Text(descriptor.label).tag(descriptor)
                }
            }

            Divider()

            let results = configuration.taxRate.rate.calculate(income: (configuration.income - configuration.pretaxDeduction))

            Text("Federal").font(.title)
            displayDollars("Amount", value: results.federalDollars)
            displayPercent("Rate", value: results.effectiveFederalRate)

            Divider()

            Text("California").font(.title)
            displayDollars("Amount", value: results.californiaDollars)
            displayPercent("Rate", value: results.effectiveCaliforniaRate)

            Divider()

            Text("Supplemental").font(.title)
            displayDollars("Social Security", value: results.socialSecurityDollars)
            displayDollars("Medicare", value: results.medicareDollars)
            displayDollars("CASDI", value: results.CASDIDollars)

            Divider()

            Text("Total").font(.title)
            displayDollars("Amount", value: results.totalDollars)
            displayPercent("Rate", value: results.totalEffectiveRate)

            Divider()
        }
    }

    private var decimalFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }

    private func displayDollars(_ title: String, value: Double) -> some View {
        let roundedNumber = floor(value * 100) / 100.0
        return LabeledContent(title, value: "$\(roundedNumber)")
    }

    private func displayPercent(_ title: String, value: Double) -> some View {
        let roundedNumber = floor(value * 100 * 100) / 100.0
        return LabeledContent(title, value: "\(roundedNumber)%")
    }
}
