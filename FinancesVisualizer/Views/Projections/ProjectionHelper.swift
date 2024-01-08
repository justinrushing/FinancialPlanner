//
//  ProjectionHelper.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/21/23.
//

import Foundation

struct ProjectedValue: Identifiable {
    var id: Date { date }
    var date: Date
    var value: Double

    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }

    func sameYearAs(date: Date) -> Bool {
        let calendar = Calendar.current
        let year1 = calendar.component(.year, from: self.date)
        let year2 = calendar.component(.year, from: date)
        return year1 == year2
    }
}

struct Projection {
    let totalSavings: [ProjectedValue]
    let yearlyContribution: [ProjectedValue]
    let targetSpending: [ProjectedValue]
}

final class ProjectionHelper {
    static let shared = ProjectionHelper()

    let calendar = Calendar.current
    let today = Date.now

    lazy var currentYear: Int = {
        calendar.component(.year, from: today)
    }()

    func projectSavings(startingValue: Double) -> Projection {
        var totalSavingsProjection = [ProjectedValue]()
        var yearlyContributionProjection = [ProjectedValue]()
        var targetSpendingProjection = [ProjectedValue]()

        let config = ConfigurationStore.shared

        var date = self.today
        var totalSavings = startingValue
        var inflationMultiplier = 1.0
        while calendar.component(.year, from: date) < 2111 {
            inflationMultiplier *= config.inflationRate

            var yearlyContribution = config.yearlyContribution * inflationMultiplier
            var targetSpending = config.targetSpending * inflationMultiplier
            if calendar.component(.year, from: date) >= config.retirementYear {
                if calendar.component(.year, from: date) >= config.socialSecurityCollectionYear {
                    yearlyContribution = config.projectedSocialSecurityIncome * 12 * inflationMultiplier
                } else {
                    yearlyContribution = 0
                }
            } else {
                targetSpending = 0
            }


            totalSavingsProjection.append(
                .init(date: date, value: totalSavings)
            )
            yearlyContributionProjection.append(
                .init(date: date, value: yearlyContribution)
            )
            targetSpendingProjection.append(
                .init(date: date, value: targetSpending)
            )


            guard let newDate = calendar.date(byAdding: .year, value: 1, to: date) else {
                break
            }
            date = newDate
            totalSavings *= config.compoundRate
            totalSavings += yearlyContribution
            totalSavings -= targetSpending
        }

        return .init(
            totalSavings: totalSavingsProjection,
            yearlyContribution: yearlyContributionProjection,
            targetSpending: targetSpendingProjection
        )
    }

}
