//
//  Options.swift
//  
//
//  Created by Eneko Alonso on 6/30/21.
//

import Foundation
import ArgumentParser

struct Options: ParsableArguments {
    @Option(
        name: [
            .customShort("i", allowingJoined: true),
            .customLong("key-file", withSingleDash: false)
        ],
        help: "File containing encryption key")
    var keyFile: String?

    @Option(
        name: [
            .customShort("p", allowingJoined: true),
            .customLong("passphrase", withSingleDash: false)
        ],
        help: "Encryption passphrase")
    var passphrase: String?

    @Option(
        name: [
            .customShort("s", allowingJoined: true),
            .customLong("salt", withSingleDash: false)
        ],
        help: "Encryption salt to be used with passphrase")
    var salt: String?

    @Argument(help: "A list of files to encrypt/decrypt")
    var filenames: [String] = []
}
