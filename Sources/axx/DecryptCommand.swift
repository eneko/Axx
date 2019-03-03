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

    enum Error: Swift.Error {
        case missingKey
        case expectedFilenames
    }

    var subparser: ArgumentParser
    var subcommands: [Command] = []

    let fileNames: PositionalArgument<[String]>
    let keyFile: OptionArgument<String>

    init(parser: ArgumentParser) {
        subparser = parser.add(subparser: command, overview: overview)
        fileNames = subparser.add(positional: "Filenames to decrypt", kind: [String].self)
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
            try decrypt(file: file, key: key)
        }
    }

    func decrypt(file: String, key: Data) throws {
        let data = try Data(contentsOf: URL(fileURLWithPath: file))
        let cipher = try AES256CBCCipher(key: key)
        let output = try cipher.decrypt(data: data)
        try output.write(to: URL(fileURLWithPath: "\(file).plain"))
    }
}
