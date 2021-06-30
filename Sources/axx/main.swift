import ArgumentParser

/// `axx` is the main command or program executable
struct Axx: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Easily encrypt/decrypt files from the command line",
        version: "0.1.0",
        subcommands: [GenerateKey.self, Encrypt.self, Decrypt.self],
        defaultSubcommand: nil
    )
}

Axx.main()
