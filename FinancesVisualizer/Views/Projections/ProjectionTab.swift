//
//  ProjectionTab.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/21/23.
//

import Foundation
import SwiftUI

struct ProjectionTab: View {
    @State var offset: Double = 0
    @ObservedObject var store = PortfolioStore.shared
    @ObservedObject var configuration = ConfigurationStore.shared

    var body: some View {
        VStack {
            totalProjectionView
            settings
        }
    }

    private var settings: some View {
        Form {
            Text("Current Savings: \(store.history.latestSnapshot.totalValue)")
            TextField("Offset", value: $offset, formatter: NumberFormatter())
            TextField("Retirement Year", value: $configuration.retirementYear, formatter: NumberFormatter())
            TextField("Social Security Year", value: $configuration.socialSecurityCollectionYear, formatter: NumberFormatter())
            TextField("Social Security Income", value: $configuration.projectedSocialSecurityIncome, formatter: NumberFormatter())
            TextField("Target Spending", value: $configuration.targetSpending, formatter: NumberFormatter())
            TextField("Inflation Rate", value: $configuration.inflationRate, formatter: decimalFormatter)
            TextField("Compound Growth Rate", value: $configuration.compoundRate, formatter: decimalFormatter)
            TextField("Yearly Contribution", value: $configuration.yearlyContribution, formatter: decimalFormatter)
        }
    }

    private var totalProjectionView: some View {
        let projections = ProjectionHelper.shared.projectSavings(
            startingValue: store.history.latestSnapshot.totalValue + offset
        )

        return VStack {
            ProjectionView(label: "Total Savings", projections: projections.totalSavings)
            ProjectionView(label: "Yearly Contributions", projections: projections.yearlyContribution)
            ProjectionView(label: "Target Spending", projections: projections.targetSpending)
        }
    }

    private var decimalFormatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }
}
