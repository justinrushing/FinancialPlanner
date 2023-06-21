//
//  PortfolioHistory.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/1/23.
//

import Foundation

struct InvestmentAccount {
    var accountID: String
    var accountName: String
    var retirementAccount: Bool

    static func unknown(accountID: String) -> InvestmentAccount {
        .init(accountID: accountID, accountName: "Unknown", retirementAccount: false)
    }
}

struct PortfolioRecord: Identifiable {
    var id: String { holding.description }

    var account: InvestmentAccount
    var holding: Holding
    var date: Date
    var currentValue: Double
}

struct Holding {
    var symbol: String
    var category: Category
    var description: String

    static func unknown(symbol: String) -> Holding {
        .init(symbol: symbol, category: .unknown, description: "Unknown")
    }

    enum Category {
        case US(USSubCategory)
        case emergingMarket
        case developedMarket
        case bond
        case cash
        case alternative(AlternativeSubCategory)
        case unknown

        enum AlternativeSubCategory {
            case managedFutures
            case privateEquity
            case realEstate
            case mixed

            var description: String {
                switch self {
                case .managedFutures: return "Managed Futures"
                case .privateEquity: return "Private Equity"
                case .realEstate: return "Real Estate"
                case .mixed: return "Mixed"
                }
            }
        }

        enum USSubCategory {
            case individual
            case smallCap
            case midCap
            case largeCap
            case total

            var description: String {
                switch self {
                case .individual: return "Individual"
                case .smallCap: return "Small Cap"
                case .midCap: return "Mid Cap"
                case .largeCap: return "Large Cap"
                case .total: return "Total"
                }
            }
        }

        var categoryDescription: String {
            switch self {
            case .US: return "US"
            case .bond: return "Bonds"
            case .cash: return "Cash"
            case .emergingMarket: return "Emerging Market"
            case .developedMarket: return "Developed Market"
            case .alternative: return "Alternative"
            case .unknown: return "Unknown"
            }
        }

        var subcategoryDescription: String {
            switch self {
            case .US(let subcategory): return "\(categoryDescription) (\(subcategory.description))"
            case .alternative(let subcategory): return "\(categoryDescription) (\(subcategory.description))"
            default: return categoryDescription
            }
        }
    }
}

struct PortfolioHistory {
    var records: [PortfolioRecord]

    var latestSnapshot: PortfolioSnapshot {
        let currentDate = records.map(\.date).max()
        let records = records.filter { $0.date == currentDate }
        return .init(records: records)
    }

    func filter(_ isIncluded: (PortfolioRecord) -> Bool) -> PortfolioHistory {
        let records = records.filter(isIncluded)
        return .init(records: records)
    }

    init(records: [PortfolioRecord]) {
        self.records = records.sorted { $0.date < $1.date }
    }
}

struct PortfolioSnapshot {
    var totalValue: Double
    var records: [PortfolioRecord]

    init(records: [PortfolioRecord]) {
        self.records = records
        self.totalValue = records
            .map(\.currentValue)
            .reduce(0, +)
    }

    func percent(record: PortfolioRecord) -> Double {
        record.currentValue / totalValue
    }
}
