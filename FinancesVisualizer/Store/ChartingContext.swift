//
//  ChartingContext.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/8/23.
//

import Foundation

struct ChartingQuery {
    enum Reducer {
        case sum
        case min
        case max
        case avg
        case count

        func reduce(values: [Double]) -> Double {
            switch self {
            case .sum: return values.reduce(0, +)
            case .min: return values.min() ?? 0
            case .max: return values.max() ?? 0
            case .avg: return values.reduce(0, +) / Double(values.count)
            case .count: return Double(values.count)
            }
        }
    }

    var reducer: Reducer
    var property: KeyPath<PortfolioRecord, Double>
    var split: KeyPath<PortfolioRecord, String>? = nil
    var grid: KeyPath<PortfolioRecord, String>? = nil

    func run(history: PortfolioHistory) -> [Chart] {
        let snapshotsByGrid = performGrid(records: history.records)

        return snapshotsByGrid.map { key, value in
            let snapshotsBySeries = performSplit(records: value)
            let series: [Chart.Series] = snapshotsBySeries.map { key, value in
                return .init(label: key, points: processPoints(records: value))
            }.sorted {
                $0.points[$0.points.count - 1].value < $1.points[$1.points.count - 1].value
            }

            return .init(name: key, series: series)
        }
    }

    private func performSplit(records: [PortfolioRecord]) -> [String: [PortfolioRecord]] {
        guard let split = split else {
            return ["All": records]
        }

        return records.organized { $0[keyPath: split] }
    }

    private func performGrid(records: [PortfolioRecord]) -> [String: [PortfolioRecord]] {
        guard let grid = grid else {
            return ["All": records]
        }

        return records.organized { $0[keyPath: grid] }
    }

    private func processPoints(records: [PortfolioRecord]) -> [Chart.Series.Point] {
        let recordsByDate = records.organized(by: \.date)
        return recordsByDate.map { date, records in
            let value = reducer.reduce(values: records.map { $0[keyPath: property] })
            return .init(date: date, value: value)
        }.sorted { $0.date < $1.date }
    }

    struct Chart: Identifiable {
        var id: String { name }
        let name: String
        let series: [Series]
        let minDate: Date?
        let maxDate: Date?

        init(name: String, series: [Series]) {
            self.name = name
            self.series = series
            self.minDate = series.flatMap(\.points).map(\.date).min()
            self.maxDate = series.flatMap(\.points).map(\.date).max()
        }

        func closestDate(to: Date?) -> Date? {
            guard let to else { return nil }

            var returnDate: Date? = nil
            for series in series {
                for point in series.points {
                    if let d = returnDate {
                        if abs(d.timeIntervalSince(to)) > abs(point.date.timeIntervalSince(to)) {
                            returnDate = point.date
                        }
                    } else {
                        returnDate = point.date
                    }
                }
            }

            return returnDate
        }

        func summary(date: Date) -> Summary {
            var values: [String: CGFloat] = [:]
            for series in series {
                for point in series.points {
                    if point.date == date {
                        values[series.label] = point.value
                    }
                }
            }

            return .init(date: date, values: values)
        }

        struct Series: Identifiable {
            var id: String { label }
            let label: String
            let points: [Point]

            struct Point: Identifiable {
                var id: Date { date }
                let date: Date
                let value: CGFloat
            }
        }

        struct Summary {
            let date: Date
            let values: [String: CGFloat]

            var total: CGFloat {
                values.values.reduce(0, +)
            }
        }
    }
}
