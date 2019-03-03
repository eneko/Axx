//
//  KeyLoader.swift
//  axx
//
//  Created by Eneko Alonso on 3/3/19.
//

import Foundation

public final class KeyLoader {

    public init() {}

    public func loadKey(file: String) throws -> Data {
        let keyData = try String(contentsOf: URL(fileURLWithPath: file))
        let key = try Base64KeyEncoder().parse(key: keyData.trimmingCharacters(in: .newlines))
        return key
    }
}
