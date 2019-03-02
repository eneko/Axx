import Foundation
import CommonCrypto

enum Error: Swift.Error {
    case encryptionError(status: CCCryptorStatus)
    case decryptionError(status: CCCryptorStatus)
}

func encrypt(data: Data, key: Data, iv: Data) throws -> Data {
    // Output buffer (with padding)
    let outputLength = data.count + kCCBlockSizeAES128
    var outputBuffer = Array<UInt8>(repeating: 0, count: outputLength)
    var numBytesEncrypted = 0

    let status = CCCrypt(CCOperation(kCCEncrypt),
                         CCAlgorithm(kCCAlgorithmAES),
                         CCOptions(kCCOptionPKCS7Padding),
                         Array(key),
                         kCCKeySizeAES256,
                         Array(iv),
                         Array(data),
                         data.count,
                         &outputBuffer,
                         outputLength,
                         &numBytesEncrypted)

    guard status == kCCSuccess else {
        throw Error.encryptionError(status: status)
    }
    let outputBytes = iv + outputBuffer.prefix(numBytesEncrypted)
    return Data(bytes: outputBytes)
}

func decrypt(data cipherData: Data, key: Data) throws -> Data {
    // Split IV and cipher text
    let iv = cipherData.prefix(kCCBlockSizeAES128)
    let cipherTextBytes = cipherData.suffix(from: kCCBlockSizeAES128)
    let cipherTextLength = cipherTextBytes.count

    // Output buffer
    var outputBuffer = Array<UInt8>(repeating: 0, count: cipherTextLength)
    var numBytesDecrypted = 0

    let status = CCCrypt(CCOperation(kCCDecrypt),
                         CCAlgorithm(kCCAlgorithmAES),
                         CCOptions(kCCOptionPKCS7Padding),
                         Array(key),
                         kCCKeySizeAES256,
                         Array(iv),
                         Array(cipherTextBytes),
                         cipherTextLength,
                         &outputBuffer,
                         cipherTextLength,
                         &numBytesDecrypted)

    guard status == kCCSuccess else {
        throw Error.decryptionError(status: status)
    }

    let outputBytes = outputBuffer.prefix(numBytesDecrypted) // Discard padding
    return Data(bytes: outputBytes)
}

let key = Data(bytes: [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2])
let iv = Data(bytes: [1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6])
let input = Data("foobar".utf8)
let ciphertext = try encrypt(data: input, key: key, iv: iv)
let plain = try decrypt(data: ciphertext, key: key)
plain == input

