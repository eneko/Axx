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

    enum Error: Swift.Error {
        case missingKey
        case expectedFilenames
    }

    let subparser: ArgumentParser
    var subcommands: [Command] = []

    let fileNames: PositionalArgument<[String]>
    let keyFile: OptionArgument<String>

    init(parser: ArgumentParser) {
        subparser = parser.add(subparser: command, overview: overview)
        fileNames = subparser.add(positional: "Filenames to encrypt", kind: [String].self)
        keyFile = subparser.add(option: "--key-file", shortName: "-i", kind: String.self,
                                usage: "File containing encryption key")
    }

    func run(with arguments: ArgumentParser.Result) throws {
        guard let files = arguments.get(fileNames), files.isEmpty == false else {
            throw Error.expectedFilenames
        }
        guard let keyFile = arguments.get(keyFile) else {
            throw Error.missingKey
        }

        let key = try KeyLoader().loadKey(file: keyFile)
        for file in files {
            try encrypt(file: file, key: key)
        }
    }

    func encrypt(file: String, key: Data) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: file))
        let cipher = try AES256CBCCipher(key: key)
        let ciphertext = try cipher.encrypt(data: data)
        try ciphertext.write(to: URL(fileURLWithPath: "\(file).enc"))
    }

}
