# axx

Encrypt / decrypt files from the command line.

![](https://cdn-images-1.medium.com/max/1600/1*xaPn6yEq6H_3TNc7ZZkDew.png)

```
$ axx
OVERVIEW: Encrypt/decrypt files from the command line

USAGE: axx <command> <options> <files>

SUBCOMMANDS:
  d                       Decrypt one or more files
  e                       Encrypt one or more files
  k                       Generate new encryption key
```

## Key File Generation

```
$ axx k > ~/.mykey.pem
```

⚠️ Keys must be kept safe and secure. Without the key, it would be impossible to recover an encrypted file.

### File Encryption

```
$ axx e -i ~/.mykey.pem secretstuff.txt
```

### File Decryption

```
$ axx d -i ~/.mykey.pem secretstuff.txt.enc
```

## Installation

### With Homebrew
```
$ brew install eneko/tap/axx
```

### From source
```
$ git clone https://github.com/eneko/Axx.git && cd Axx
$ make install
```
