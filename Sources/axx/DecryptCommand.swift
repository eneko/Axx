//
//  DecryptCommand.swift
//  axx
//
//  Created by Eneko Alonso on 3/1/19.
//

import Foundation
import Utility
import CommandRegistry
import Crypto

final class DecryptCommand: Command {
    let command = "d"
    let overview = "Decrypt one or more files"

    var subparser: ArgumentParser
    var subcommands: [Command] = []

    enum Error: Swift.Error {
        case errorLoadingFile
    }

    init(parser: ArgumentParser) {
        subparser = parser.add(subparser: command, overview: overview)
    }

    func run(with arguments: ArgumentParser.Result) throws {
        let ciphertext = try Data(contentsOf: URL(fileURLWithPath: "test.txt.bin"))
        let cipher = try AES256CBCCipher(passphrase: "foo", salt: "bar")
        let plain = try cipher.decrypt(data: ciphertext)
        try plain.write(to: URL(fileURLWithPath: "test.txt.plain"))
    }

}
