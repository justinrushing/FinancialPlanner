//
//  FidelityPortfolioParser.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/1/23.
//

import Foundation
import SwiftCSV

struct FidelityPortfolioSnapshot {
    var date: Date
    var records: [Record]

    struct Record {
        var accountNumber: String = ""
        var accountName: String = ""
        var costBasisTotal: Double = 0
        var currentValue: Double = 0
        var totalGainLossDollar: Double = 0
        var symbol: String = ""
        var description: String = ""

        init(dict: [String: Any]) throws {
            let decoder = DictionaryDecoder(dict: dict, type: CodingKeys.self)
            self.accountNumber = try decoder.decode(key: .accountNumber)
            self.accountName = try decoder.decode(key: .accountName)
            self.costBasisTotal = try decoder.decodeDollar(key: .costBasisTotal)
            self.currentValue = try decoder.decodeDollar(key: .currentValue)
            self.totalGainLossDollar = try decoder.decodeDollar(key: .totalGainLossDollar)
            self.symbol = try decoder.decode(key: .symbol)
            self.description = try decoder.decode(key: .description)
        }

        private enum CodingKeys: String, CodingKey {
            // NOTE: This has a weird unprintable character at the front
            case accountNumber = "﻿Account Number"
            case accountName = "Account Name"
            case costBasisTotal = "Cost Basis Total"
            case currentValue = "Current Value"
            case totalGainLossDollar = "Total Gain/Loss Dollar"
            case symbol = "Symbol"
            case description = "Description"
        }
    }
}

final class FidelityPortfolioParser {
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM-dd-yyyy"
        return formatter
    }()

    func parseDirectory(path: String) throws -> [FidelityPortfolioSnapshot] {
        let contents = try FileManager.default.contentsOfDirectory(atPath: path)
        return contents.compactMap {
            self.parse(path: (path as NSString).appendingPathComponent($0))
        }
    }

    func parse(path: String) -> FidelityPortfolioSnapshot? {
        guard let date = date(path: path) else {
            return nil
        }

        guard let data = FileManager.default.contents(atPath: path) else {
            return nil
        }

        guard let string = String(data: data, encoding: .utf8) else {
            return nil
        }

        var records = [FidelityPortfolioSnapshot.Record]()
        do {
            let csvFile: CSV = try CSV<Named>(string: string)
            try csvFile.enumerateAsDict { dict in
                do {
                    let record = try FidelityPortfolioSnapshot.Record(dict: dict)
                    records.append(record)
                } catch {
                    print("Error parsing record: \(error)")
                }
            }
        } catch {}

        return .init(date: date, records: records)
    }

    private func date(path: String) -> Date? {
        let fileName = (path as NSString).lastPathComponent
        guard let dateString = fileName.components(separatedBy: "_").last?.replacingOccurrences(of: ".csv", with: "") else {
            return nil
        }

        return dateFormatter.date(from: dateString)
    }
}
