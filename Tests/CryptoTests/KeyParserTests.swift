//
//  KeyParserTests.swift
//  CryptoTests
//
//  Created by Eneko Alonso on 3/1/19.
//

import XCTest
import Crypto

class KeyParserTests: XCTestCase {

    let mockOpenSSHKey = """
        -----BEGIN OPENSSH PRIVATE KEY-----
        SGVsbG8g
        d29ybGQh
        -----END OPENSSH PRIVATE KEY-----
        """

    let mockRSAKey = """
        -----BEGIN RSA PRIVATE KEY-----
        SGVsbG8g
        d29ybGQh
        -----END RSA PRIVATE KEY-----
        """

    let mockPrivateKey = """
        -----BEGIN PRIVATE KEY-----
        SGVsbG8g
        d29ybGQh
        -----END PRIVATE KEY-----
        """

    func testOpenSSHKey() throws {
        let key = try KeyParser().parse(key: mockOpenSSHKey)
        XCTAssertEqual(String(data: key, encoding: .utf8), "Hello world!")
    }

    func testRSAKey() throws {
        let key = try KeyParser().parse(key: mockRSAKey)
        XCTAssertEqual(String(data: key, encoding: .utf8), "Hello world!")
    }

    func testPrivateKey() throws {
        let key = try KeyParser().parse(key: mockPrivateKey)
        XCTAssertEqual(String(data: key, encoding: .utf8), "Hello world!")
    }

}
