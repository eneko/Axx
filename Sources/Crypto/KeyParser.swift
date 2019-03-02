//
//  KeyParser.swift
//  Crypto
//
//  Created by Eneko Alonso on 3/1/19.
//

import Foundation

public final class KeyParser {

    let supportedKeyTypes = [
        "-----BEGIN OPENSSH PRIVATE KEY-----",
        "-----BEGIN RSA PRIVATE KEY-----",
        "-----BEGIN PRIVATE KEY-----"
    ]

    public enum Error: Swift.Error {
        case unsupportedKey
        case invalidKey
    }

    public init() {}

    public func parse(key: String) throws -> Data {
        let lines = key.components(separatedBy: .newlines)
        guard let firstLine = lines.first, supportedKeyTypes.contains(firstLine) else {
            throw Error.unsupportedKey
        }
        let key = lines.dropFirst().dropLast().joined()
        guard let data = Data(base64Encoded: key) else {
            throw Error.invalidKey
        }
        return data
    }
}
