//
//  AxxCryptoTests.swift
//  axx
//
//  Created by Eneko Alonso on 3/1/19.
//

import XCTest
import AxxCrypto

class CryptoTests: XCTestCase {

    func testCipher() throws {
        let cipher = try AES256CBCCipher(passphrase: "foo", salt: "bar")
        let data = Data([0, 1, 2, 3, 4, 5, 6, 7])
        let ciphertext = try cipher.encrypt(data: data)
        XCTAssertEqual(data, try cipher.decrypt(data: ciphertext))
    }

    func testEncoder() throws {
        let key = try PBKDF2Derivator().derivateKey(from: "foo", salt: "bar")
        let encoded = Base64KeyEncoder().encode(key: key)
        let decoded = try Base64KeyEncoder().parse(key: encoded)
        XCTAssertEqual(key, decoded)
    }
}
