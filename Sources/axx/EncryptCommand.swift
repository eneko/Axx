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
        case errorLoadingFile(fileName: String)
        case expectedFilenames
    }

    let subparser: ArgumentParser
    var subcommands: [Command] = []

    let fileNames: PositionalArgument<[String]>
    let passphrase: OptionArgument<Bool>
    let salt: OptionArgument<String>

    init(parser: ArgumentParser) {
        subparser = parser.add(subparser: command, overview: overview)
        fileNames = subparser.add(positional: "Filenames to encrypt", kind: [String].self)
        passphrase = subparser.add(option: "--passphrase", shortName: "-p", kind: Bool.self, usage: "Encrypt using passphrase")
        salt = subparser.add(option: "--salt", shortName: "-s", kind: String.self, usage: "Increase security with encryption passphrase salt")
    }

    func run(with arguments: ArgumentParser.Result) throws {
        guard let files = arguments.get(fileNames), files.isEmpty == false else {
            throw Error.expectedFilenames
        }
        print(files)
        let data = try Data(contentsOf: URL(fileURLWithPath: "test.txt"))
        let cipher = try AES256CBCCipher(passphrase: "foo", salt: "bar")
        let ciphertext = try cipher.encrypt(data: data)
        try ciphertext.write(to: URL(fileURLWithPath: "test.txt.bin"))
    }

}
