//
//  GenerateKeyCommand.swift
//  axx
//
//  Created by Eneko Alonso on 3/3/19.
//

import Foundation
import Utility
import CommandRegistry
import Crypto

final class GenerateKeyCommand: Command {
    let command = "k"
    let overview = "Generate new encryption key"

    var subparser: ArgumentParser
    var subcommands: [Command] = []

    enum Error: Swift.Error {
        case errorLoadingFile
    }

    init(parser: ArgumentParser) {
        subparser = parser.add(subparser: command, overview: overview)
    }

    func run(with arguments: ArgumentParser.Result) throws {
        let key = try AES256KeyGenerator().makeKey()
        let encodedKey = Base64KeyEncoder().encode(key: key)
        print(encodedKey)
    }

}
