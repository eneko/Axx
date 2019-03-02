//
//  CryptoTests.swift
//  axx
//
//  Created by Eneko Alonso on 3/1/19.
//

import XCTest
import Crypto

class CryptoTests: XCTestCase {

    func testCipher() throws {
        let cipher = try AES256CBCCipher(passphrase: "foo", salt: "bar")
        let data = Data(bytes: [0, 1, 2, 3, 4, 5, 6, 7])
        let ciphertext = try cipher.encrypt(data: data)
        XCTAssertEqual(data, try cipher.decrypt(data: ciphertext))
    }

}
