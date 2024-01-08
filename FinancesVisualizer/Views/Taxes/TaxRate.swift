//
//  TaxRate.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 11/14/23.
//

import Foundation

struct TaxRate {
    struct TaxBracket {
        var income: Double
        var rate: Double
    }

    struct SupplementalTax {
        var rate: Double
        var maxIncome: Double
        var deduction: Double = 0
    }

    struct TaxResult {
        let californiaDollars: Double
        let federalDollars: Double
        let socialSecurityDollars: Double
        let medicareDollars: Double
        let CASDIDollars: Double
        let income: Double

        var effectiveCaliforniaRate: Double { californiaDollars / income }
        var effectiveFederalRate: Double { federalDollars / income }

        var totalDollars: Double { californiaDollars + federalDollars + socialSecurityDollars + medicareDollars + CASDIDollars }
        var totalEffectiveRate: Double { totalDollars / income }
    }

    let californiaBrackets: [TaxBracket]
    let federalBrackets: [TaxBracket]
    let socialSecurityTax: SupplementalTax
    let medicareTax: SupplementalTax
    let additionalMedicareTax: SupplementalTax
    let CASDITax: SupplementalTax
}

extension TaxRate {
    /// Calculates the tax rate on a given income
    func calculate(income: Double) -> TaxResult {
        let californiaTaxes = calculateTotalTaxes(income: income, brackets: californiaBrackets)
        let federalTaxexs = calculateTotalTaxes(income: income, brackets: federalBrackets)
        let socialSecurity = calculateSupplemental(income: income, tax: socialSecurityTax)
        let medicare = calculateSupplemental(income: income, tax: medicareTax) + calculateSupplemental(income: income, tax: additionalMedicareTax)
        let CASDI = calculateSupplemental(income: income, tax: CASDITax)

        return .init(
            californiaDollars: californiaTaxes,
            federalDollars: federalTaxexs,
            socialSecurityDollars: socialSecurity,
            medicareDollars: medicare,
            CASDIDollars: CASDI,
            income: income
        )
    }

    private func calculateSupplemental(income: Double, tax: SupplementalTax) -> Double {
        return max(min(tax.maxIncome, (income - tax.deduction)), 0) * tax.rate
    }

    private func calculateTotalTaxes(income: Double, brackets: [TaxBracket]) -> Double {
        var previousBracket: TaxBracket? = nil
        var dollars: Double = 0
        for bracket in brackets {
            let previousIncome = previousBracket?.income ?? 0
            let computedIncome = max(
                min(income, bracket.income), 0
            )
            let difference = computedIncome - previousIncome

            if difference <= 0 {
                break
            }

            dollars += difference * bracket.rate
            previousBracket = bracket
        }

        return dollars
    }
}

// MARK: - Tax Rates

enum TaxRateDescriptor: String, Codable, Hashable, CaseIterable, Identifiable {
    case marriedFilingJointly2023
    case marriedFilingJointly2024

    static var defaultRate: Self = .marriedFilingJointly2024

    var id: String { rawValue }

    var label: String {
        switch self {
        case .marriedFilingJointly2023:
            return "Married Filing Jointly (2023)"
        case .marriedFilingJointly2024:
            return "Married Filing Jointly (2024)"
        }
    }

    var rate: TaxRate {
        switch self {
        case .marriedFilingJointly2023:
            return TaxRate(
                californiaBrackets: [
                    .init(income: 20198, rate: 0.01),
                    .init(income: 47884, rate: 0.02),
                    .init(income: 75576, rate: 0.04),
                    .init(income: 104910, rate: 0.06),
                    .init(income: 132590, rate: 0.08),
                    .init(income: 677278, rate: 0.093),
                    .init(income: 812728, rate: 0.103),
                    .init(income: 1354550, rate: 0.113),
                    .init(income: .greatestFiniteMagnitude, rate: 0.123)
                ],
                federalBrackets: [
                    .init(income: 22000, rate: 0.1),
                    .init(income: 89450, rate: 0.12),
                    .init(income: 190750, rate: 0.22),
                    .init(income: 364200, rate: 0.24),
                    .init(income: 462500, rate: 0.32),
                    .init(income: 693750, rate: 0.35),
                    .init(income: .greatestFiniteMagnitude, rate: 0.37)
                ],
                socialSecurityTax: .init(rate: 0.062, maxIncome: 160200),
                medicareTax: .init(rate: 0.0145, maxIncome: .greatestFiniteMagnitude),
                additionalMedicareTax: .init(rate: 0.009, maxIncome: .greatestFiniteMagnitude, deduction: 250000),
                CASDITax: .init(rate: 0.009, maxIncome: 153164)
            )
        case .marriedFilingJointly2024:
            return TaxRate(
                californiaBrackets: [
                    .init(income: 20198, rate: 0.01),
                    .init(income: 47884, rate: 0.02),
                    .init(income: 75576, rate: 0.04),
                    .init(income: 104910, rate: 0.06),
                    .init(income: 132590, rate: 0.08),
                    .init(income: 677278, rate: 0.093),
                    .init(income: 812728, rate: 0.103),
                    .init(income: 1354550, rate: 0.113),
                    .init(income: 100000000, rate: 0.123)
                ],
                federalBrackets: [
                    .init(income: 23200, rate: 0.1),
                    .init(income: 94300, rate: 0.12),
                    .init(income: 201050, rate: 0.22),
                    .init(income: 383900, rate: 0.24),
                    .init(income: 487450, rate: 0.32),
                    .init(income: 731200, rate: 0.35),
                    .init(income: 100000000, rate: 0.37)
                ],
                socialSecurityTax: .init(rate: 0.062, maxIncome: 168600),
                medicareTax: .init(rate: 0.0145, maxIncome: .greatestFiniteMagnitude),
                additionalMedicareTax: .init(rate: 0.009, maxIncome: .greatestFiniteMagnitude, deduction: 250000),
                CASDITax: .init(rate: 0.009, maxIncome: .greatestFiniteMagnitude)
            )
        }
    }
}
