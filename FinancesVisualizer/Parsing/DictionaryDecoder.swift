//
//  DictionaryDecoder.swift
//  FinancesVisualizer
//
//  Created by Justin Rushing on 6/1/23.
//

import Foundation

struct DictionaryDecoder<CK: CodingKey> where CK: RawRepresentable, CK.RawValue == String {
    let dict: [String: Any]

    init(dict: [String : Any], type: CK.Type) {
        self.dict = dict
    }

    func decode<T>(
        key: CK
    ) throws -> T {
        guard let value = dict[key.rawValue] else {
            throw DecodingError.keyNotFound(key, .init(codingPath: [key], debugDescription: "No key found for \(key)"))
        }
        guard let unwrapped = value as? T else {
            throw DecodingError.typeMismatch(T.self, .init(codingPath: [key], debugDescription: "Unexpected type found for \(value). Should be \(T.self)"))
        }
        return unwrapped
    }

    func decodeDollar(key: CK) throws -> Double {
        try parseDollar(decode(key: key))
    }

    private func parseDollar(_ string: String) -> Double {
        (string.replacingOccurrences(of: "$", with: "") as NSString).doubleValue
    }
}
