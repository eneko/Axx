# axx

Encrypt / decrypt files from the command line.

![](https://cdn-images-1.medium.com/max/1600/1*xaPn6yEq6H_3TNc7ZZkDew.png)

```
$ axx
OVERVIEW: Easily encrypt/decrypt files from the command line

USAGE: axx <subcommand>

OPTIONS:
  --version               Show the version.
  -h, --help              Show help information.

SUBCOMMANDS:
  k                       Generate an encryption key
  e                       Encrypt one or more files
  d                       Decrypt one or more files

  See 'axx help <subcommand>' for detailed help.
```

## Usage

### Key Generation

With Axx is very easy to generate AES 256 encryption keys.
```
$ axx k > ~/.mykey.pem
```

⚠️ Keys must be kept safe and secure. Without the key, it would be impossible to recover an encrypted file.

### File Encryption

Axx supports file encryption with key, passphrase, or passphrase + salt.

With key:
```
$ axx e -i ~/.mykey.pem secretstuff.txt
```

With passphrase:
```
$ axx e -p pass secretstuff.txt
```

With passphrase and salt:
```
$ axx e -p pass -s sugar secretstuff.txt
```

### File Decryption

Axx supports file decryption with key, passphrase, or passphrase + salt.

With key:
```
$ axx d -i ~/.mykey.pem secretstuff.txt.enc
```

With passphrase:
```
$ axx d -p pass secretstuff.txt.enc
```

With passphrase and salt:
```
$ axx d -p pass -s sugar secretstuff.txt.enc
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
