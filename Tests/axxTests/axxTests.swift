import XCTest
import class Foundation.Bundle

final class axxTests: XCTestCase {

    func testHelp() throws {
        let output = try axx(with: [])
        XCTAssertTrue(output.hasPrefix("OVERVIEW: Easily encrypt/decrypt files from the command line"))
    }

    func testEncryptDecrypt() throws {
        let input = "I 🧡 Swift"
        try input.write(toFile: "input.txt", atomically: true, encoding: .utf8)
        try axx(with: ["e", "-p", "secret password", "input.txt"])
        try axx(with: ["d", "-p", "secret password", "input.txt.enc"])
        let output = try String(contentsOfFile: "input.txt.enc.plain")
        XCTAssertEqual(input, output)
    }

    @discardableResult
    func axx(with arguments: [String]) throws -> String {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return ""
        }

        let fooBinary = productsDirectory.appendingPathComponent("axx")

        let process = Process()
        process.executableURL = fooBinary
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)
        return output ?? ""
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

}
