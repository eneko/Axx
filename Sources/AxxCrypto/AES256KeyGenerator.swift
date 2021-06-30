//
//  AES256KeyGenerator.swift
//  AxxCrypto
//
//  Created by Eneko Alonso on 3/3/19.
//

import Foundation
import CommonCrypto

public final class AES256KeyGenerator {
    public enum Error: Swift.Error {
        case keyGenerationFailed(status: OSStatus)
    }

    public init() {}

    public func makeKey() throws -> Data {
        var bytes = Array<UInt8>(repeating: 0, count: kCCKeySizeAES256)
        let status = SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES256, &bytes)
        guard status == errSecSuccess else {
            throw Error.keyGenerationFailed(status: status)
        }
        return Data(bytes)
    }
}
