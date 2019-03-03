//
//  Base64KeyEncoder.swift
//  Crypto
//
//  Created by Eneko Alonso on 3/1/19.
//

import Foundation

public final class Base64KeyEncoder {

    let beginKey = "-----BEGIN KEY-----"
    let endKey = "-----END KEY-----"

    public enum Error: Swift.Error {
        case unsupportedKey
        case invalidKey
    }

    public init() {}

    public func parse(key: String) throws -> Data {
        let lines = key.components(separatedBy: .newlines)
        guard lines.count == 3, lines.first == beginKey, lines.last == endKey else {
            throw Error.unsupportedKey
        }
        guard let data = Data(base64Encoded: lines[1]) else {
            throw Error.invalidKey
        }
        return data
    }

    public func encode(key: Data) -> String {
        return """
        \(beginKey)
        \(key.base64EncodedString())
        \(endKey)
        """
    }
}
