//
//  EncryptCommand.swift
//  axx
//
//  Created by Eneko Alonso on 3/1/19.
//

import Foundation
import Utility
import CommandRegistry
import Crypto

final class EncryptCommand: Command {
    let command = "e"
    let overview = "Encrypt one or more files"

    var subparser: ArgumentParser
    var subcommands: [Command] = []

    enum Error: Swift.Error {
        case errorLoadingFile
    }

    init(parser: ArgumentParser) {
        subparser = parser.add(subparser: command, overview: overview)
    }

    func run(with arguments: ArgumentParser.Result) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: "test.txt"))
        let cipher = try AES256CBCCipher(passphrase: "foo", salt: "bar")
        let ciphertext = try cipher.encrypt(data: data)
        try ciphertext.write(to: URL(fileURLWithPath: "test.txt.bin"))
    }
    
}
