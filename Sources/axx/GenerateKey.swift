//
//  GenerateKeyCommand.swift
//  axx
//
//  Created by Eneko Alonso on 3/3/19.
//

import Foundation
import ArgumentParser
import AxxCrypto

extension Axx {
    struct GenerateKey: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "k",
            abstract: "Generate an encryption key"
        )

        mutating func run() throws {
            let key = try AES256KeyGenerator().makeKey()
            let encodedKey = Base64KeyEncoder().encode(key: key)
            print(encodedKey)
        }
    }
}
