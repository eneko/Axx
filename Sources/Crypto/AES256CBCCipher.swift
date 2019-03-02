//
//  AES256CBCCipher.swift
//  Conduit
//
//  Created by Eneko Alonso on 2/25/19.
//  Copyright © 2019 MINDBODY. All rights reserved.
//

import Foundation
import CommonCrypto

/// AES-256 Cipher Block Chaining (CBC) cipher
///
/// 256bit (32 byte) encryption key can be passed in as binary, or it can be
/// derivated from a give pass phrase (using PBKDF2 algorithm).
///
/// An optional 128bit (16 byte) initialization vector can be passed to the
/// encryption method. If no IV is passed, a random IV will be generated.
/// IV is stored in the encryption data, together with the ciphertext and it
/// is not required to be passed in for decryption.
public final class AES256CBCCipher {

    let encryptionKey: Data

    public enum Error: Swift.Error {
        case invalidKey
        case invalidInitializationVector
        case encryptionError
        case decryptionError
    }

    /// Initialize AES-256 CBC cipher with a given pass phrase
    ///
    /// - Parameters:
    ///   - passphrase: Passphrase string to use for encryption key derivation.
    ///   - salt: Salt to be used for key derivation.
    /// - Throws: Exception if key derivation failed
    public convenience init(passphrase: String, salt: String) throws {
        let derivatedKey = try PBKDF2Derivator().derivateKey(from: passphrase, salt: salt)
        try self.init(key: derivatedKey)
    }

    /// Initialize AES-256 CBC cipher with a binary encryption key
    ///
    /// - Parameter key: 256-bit (32 byte) binary encryption key
    /// - Throws: Exception if key is invalid
    public init(key: Data) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw Error.invalidKey
        }
        encryptionKey = key
    }

    /// AES 256-bit CBC encryption
    ///
    /// Encrypt data with AES 256 CBC.
    /// Cipher data is prefixed with the initialization vector:
    ///
    ///     VVVV VVVV VVVV VVVV DDDD DDDD DDDD DDDD DDDD DDDD DDDD DDDD ...
    ///     \_______ IV ______/ \_ Cipher Block 1_/ \_ Cipher Block 2_/
    ///
    /// Initialization vector (IV) length is equivalent to a cipher
    /// block (`kCCBlockSizeAES128` == 16 bytes). This length is
    /// independent of the key length (`kCCKeySizeAES256` == 32 bytes).
    ///
    /// - Parameters:
    ///   - data: Data to be encrypted
    ///   - vector: Optional initialization vector (defaults to random vector)
    /// - Returns: Encrypted data prefixed with IV
    /// - Throws: Exception if encryption failed
    public func encrypt(data: Data, iv vector: Data? = nil) throws -> Data {
        let initializationVector = vector.flatMap(Array.init) ?? randomInitializationVector
        guard initializationVector.count == kCCBlockSizeAES128 else {
            throw Error.invalidInitializationVector
        }

        // Output buffer
        let outputLength = data.count + kCCBlockSizeAES128 // Buffer padding
        var outputBuffer = Array<UInt8>(repeating: 0, count: outputLength)
        var numBytesEncrypted = 0

        let status = CCCrypt(CCOperation(kCCEncrypt),
                             CCAlgorithm(kCCAlgorithmAES),
                             CCOptions(kCCOptionPKCS7Padding),
                             Array(encryptionKey),
                             kCCKeySizeAES256,
                             initializationVector,
                             Array(data),
                             data.count,
                             &outputBuffer,
                             outputLength,
                             &numBytesEncrypted)

        guard status == kCCSuccess else {
            throw Error.encryptionError
        }

        let outputBytes = initializationVector + outputBuffer.prefix(numBytesEncrypted)
        return Data(bytes: outputBytes)
    }

    /// AES 256-bit CBC decryption
    ///
    /// Decrypt cipher data previously encrypted with AES 256 CBC.
    /// Cipher data must be prefixed with the initialization vector:
    ///
    ///     VVVV VVVV VVVV VVVV DDDD DDDD DDDD DDDD DDDD DDDD DDDD DDDD ...
    ///     \_______ IV ______/ \_ Cipher Block 1_/ \_ Cipher Block 2_/
    ///
    /// Initialization vector must be exactly 16 bytes (`kCCBlockSizeAES128`).
    /// Ciphertext data must contain at least one cipher block (`kCCBlockSizeAES128`).
    ///
    /// - Parameter cipherData: Cipher data with IV prefix
    /// - Returns: Decrypted data
    /// - Throws: Exception if decryption failed
    public func decrypt(data cipherData: Data) throws -> Data {
        let initializationVector = Array(cipherData.prefix(kCCBlockSizeAES128))
        guard initializationVector.count == kCCBlockSizeAES128 else {
            throw Error.invalidInitializationVector
        }

        let cipherTextBytes = Array(cipherData.suffix(from: kCCBlockSizeAES128))
        let cipherTextLength = cipherTextBytes.count
        guard cipherTextLength >= kCCBlockSizeAES128 else {
            throw Error.decryptionError
        }

        // Output buffer
        var outputBuffer = Array<UInt8>(repeating: 0, count: cipherTextLength)
        var numBytesDecrypted = 0

        let status = CCCrypt(CCOperation(kCCDecrypt),
                             CCAlgorithm(kCCAlgorithmAES),
                             CCOptions(kCCOptionPKCS7Padding),
                             Array(encryptionKey),
                             kCCKeySizeAES256,
                             initializationVector,
                             cipherTextBytes,
                             cipherTextLength,
                             &outputBuffer,
                             cipherTextLength,
                             &numBytesDecrypted)

        guard status == kCCSuccess else {
            throw Error.decryptionError
        }

        let outputBytes = outputBuffer.prefix(numBytesDecrypted) // Discard any padding
        return Data(bytes: outputBytes)
    }

    /// Generate a random 128bit (16 byte) initialization vector
    var randomInitializationVector: [UInt8] {
        return (1...kCCBlockSizeAES128).map { _ in UInt8.random(in: 0...UInt8.max) }
    }
}
