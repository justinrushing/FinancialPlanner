//
//  PortfolioMetadataStore.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/8/23.
//

import Foundation

final class PortfolioMetadataStore: ObservableObject {
    public static let shared = PortfolioMetadataStore()

    @Published var accountsByID: [String: InvestmentAccount] = Constants.accounts.dictionary(keyedBy: \.accountID)
    @Published var holdingsBySymbol: [String: Holding] = Constants.holdings.dictionary(keyedBy: \.symbol)

    func account(id: String) -> InvestmentAccount {
        accountsByID[id] ?? .unknown(accountID: id)
    }

    func holding(symbol: String) -> Holding {
        holdingsBySymbol[symbol] ?? .unknown(symbol: symbol)
    }
}

private enum Constants {
    static let accounts: [InvestmentAccount] = [
        .init(accountID: "Z07438098", accountName: "Justin - Managed Investments", retirementAccount: false),
        .init(accountID: "Z07755656", accountName: "Joint - Self Directed Investments", retirementAccount: false),
        .init(accountID: "Z23451434", accountName: "Joint - Managed Investments", retirementAccount: false),
        .init(accountID: "235927060", accountName: "Justin - Managed Roth IRA", retirementAccount: true),
        .init(accountID: "239508010", accountName: "Justin - Managed Rollover IRA", retirementAccount: true),
        .init(accountID: "X85825584", accountName: "Joint - Checking", retirementAccount: true),
        .init(accountID: "618457046", accountName: "Joint - 529 Account", retirementAccount: false)
    ]

    static let holdings: [Holding] = [
        .init(symbol: "56199P818", category: .alternative(.privateEquity), description: "AMG PANTHEON FUND LLC WHEN ISSUE"),
        .init(symbol: "001700137", category: .alternative(.privateEquity), description: "AMG PANTHEON FUND LLC WHEN ISSUE"),
        .init(symbol: "XPEBX", category: .alternative(.privateEquity), description: "AMG PANTHEON FUND LLC WHEN ISSUE"),
        .init(symbol: "85570X405", category: .alternative(.realEstate), description: "STARWOOD REAL ESTATE INCOME TR COM CL I"),
        .init(symbol: "BND", category: .bond, description: "VANGUARD BD INDEX FDS TOTAL BND MRKT"),
        .init(symbol: "CORE**", category: .cash, description: "FDIC-INSURED DEPOSIT SWEEP"),
        .init(symbol: "DBMF", category: .alternative(.managedFutures), description: "LITMAN GREGORY FDS TR IMGP DBI MANAGED"),
        .init(symbol: "FDRXX**", category: .cash, description: "FIDELITY GOVERNMENT CASH RESERVES"),
        .init(symbol: "FXAIX", category: .US(.largeCap), description: "FIDELITY 500 INDEX FUND"),
        .init(symbol: "IDEV", category: .developedMarket, description: "ISHARES TR CORE MSCI INTL"),
        .init(symbol: "IEMG", category: .emergingMarket, description: "ISHARES INC CORE MSCI EMERGING MKTS ETF"),
        .init(symbol: "IJR", category: .US(.smallCap), description: "ISHARES CORE S&P SMALL-CAP E"),
        .init(symbol: "IVV", category: .US(.largeCap), description: "ISHARES CORE S&P 500 ETF"),
        .init(symbol: "MASFX", category: .alternative(.mixed), description: "PARTNER SELECT ALT STRATEGIES INSTL"),
        .init(symbol: "RIVN", category: .US(.largeCap), description: "RIVIAN AUTOMOTIVE INC COM CL A"),
        .init(symbol: "SCHV", category: .US(.largeCap), description: "SCHWAB US LARGE-CAP VALUE ETF"),
        .init(symbol: "SPAXX**", category: .cash, description: "FIDELITY GOVERNMENT MONEY MARKET"),
        .init(symbol: "VBR", category: .US(.smallCap), description: "VANGUARD SMALL CAP VALUE ETF"),
        .init(symbol: "VCADX", category: .bond, description: "VANGUARD CALI INTERM TAX XMPT ADMIRAL"),
        .init(symbol: "VEA", category: .developedMarket, description: "VANGUARD DEVELOPED MARKETS INDEX FUND ETF"),
        .init(symbol: "VOE", category: .US(.midCap), description: "VANGUARD MID-CAP VALUE INDEX FUND"),
        .init(symbol: "VOO", category: .US(.largeCap), description: "VANGUARD INDEX FUNDS S&P 500 ETF USD"),
        .init(symbol: "VTI", category: .US(.total), description: "VANGUARD INDEX FDS VANGUARD TOTAL STK MKT ETF"),
        .init(symbol: "VTV", category: .US(.largeCap), description: "VANGUARD INDEX FDS VANGUARD VALUE ETF FORMERLY VANGUARD INDEX TR"),
        .init(symbol: "VTWO", category: .US(.smallCap), description: "VANGUARD RUSSELL 2000 ETF"),
        .init(symbol: "VWO", category: .emergingMarket, description: "VANGUARD INTL EQUITY INDEX FDS FTSE EMR MKT ETF"),
        .init(symbol: "NHFSMKX98", category: .US(.largeCap), description: "NH FIDELITY 500 INDEX"),
        .init(symbol: "**", category: .cash, description: "Unidentified Cash"),
        .init(symbol: "", category: .cash, description: "Unidentified Cash"),
        .init(symbol: "CRM", category: .US(.largeCap), description: "Salesforce, Inc."),
        .init(symbol: "STWD", category: .alternative(.realEstate), description: "Starwood"),
        .init(symbol: "USIG", category: .bond, description: "iShares Broad USD Investment Grade Corporate Bond ETF"),
        .init(symbol: "AAPL", category: .US(.largeCap), description: "Apple"),
        .init(symbol: "91282CCT6", category: .bond, description: "US Treasury 1 year")
    ]
}
