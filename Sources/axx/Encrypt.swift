//
//  Encrypt.swift
//  axx
//
//  Created by Eneko Alonso on 3/1/19.
//

import Foundation
import ArgumentParser
import AxxCrypto

extension Axx {
    struct Encrypt: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "e",
            abstract: "Encrypt one or more files"
        )

        @OptionGroup var options: Options

        enum Error: Swift.Error {
            case missingKeyOrPassphrase
            case expectedFilenames
        }

        mutating func run() throws {
            guard options.filenames.isEmpty == false else {
                throw Error.expectedFilenames
            }

            if let keyFile = options.keyFile {
                let key = try KeyLoader().loadKey(file: keyFile)
                for file in options.filenames {
                    try encrypt(file: file, key: key)
                }
            }
            else if let passphrase = options.passphrase {
                for file in options.filenames {
                    try encrypt(file: file,
                                passphrase: passphrase,
                                salt: options.salt)
                }
            }
            else {
                throw Error.missingKeyOrPassphrase
            }
        }

        func encrypt(file: String, key: Data) throws {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            let cipher = try AES256CBCCipher(key: key)
            let ciphertext = try cipher.encrypt(data: data)
            try ciphertext.write(to: URL(fileURLWithPath: "\(file).enc"))
        }

        func encrypt(file: String, passphrase: String, salt: String?) throws {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            let cipher = try AES256CBCCipher(passphrase: passphrase,
                                             salt: salt ?? "")
            let cipherText = try cipher.encrypt(data: data)
            try cipherText.write(to: URL(fileURLWithPath: "\(file).enc"))
        }
    }
}
