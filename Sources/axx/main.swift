import CommandRegistry

var program = CommandRegistry(usage: "<command> <options> <files>",
                              overview: "Encrypt/decrypt files from the command line")

program.register(command: DecryptCommand.self)
program.register(command: EncryptCommand.self)

program.run()
