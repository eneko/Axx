//
//  Decrypt.swift
//  axx
//
//  Created by Eneko Alonso on 3/1/19.
//

import Foundation
import ArgumentParser
import AxxCrypto

extension Axx {
    struct Decrypt: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "d",
            abstract: "Decrypt one or more files"
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
                    try decrypt(file: file, key: key)
                }
            }
            else if let passphrase = options.passphrase {
                for file in options.filenames {
                    try decrypt(file: file,
                                passphrase: passphrase,
                                salt: options.salt)
                }
            }
            else {
                throw Error.missingKeyOrPassphrase
            }
        }

        func decrypt(file: String, key: Data) throws {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            let cipher = try AES256CBCCipher(key: key)
            let output = try cipher.decrypt(data: data)
            try output.write(to: URL(fileURLWithPath: "\(file).plain"))
        }

        func decrypt(file: String, passphrase: String, salt: String?) throws {
            let data = try Data(contentsOf: URL(fileURLWithPath: file))
            let cipher = try AES256CBCCipher(passphrase: passphrase,
                                             salt: salt ?? "")
            let plainText = try cipher.decrypt(data: data)
            try plainText.write(to: URL(fileURLWithPath: "\(file).plain"))
        }
    }
}
