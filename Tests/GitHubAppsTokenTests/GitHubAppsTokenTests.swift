//
//  TestJWTCreator.swift
//
//
//  Created by Yuya Oka on 2023/02/16.
//

import ArgumentParser
import GitHubApps
import XCTest

final class GitHubAppsTokenTests: XCTestCase {
    func testVersion() throws {
        let pipe = Pipe()
        let process = process(
            withArguments: ["--version"],
            pipe: pipe
        )

        XCTAssertNoThrow(try process.run())
        process.waitUntilExit()
        XCTAssertEqual(ExitCode(process.terminationStatus), .success)

        let version = try XCTUnwrap(pipe.readStandardOutput())

        XCTAssertEqual(version, GitHubApps.version)
    }
}

// MARK: - Private
private extension GitHubAppsTokenTests {
    static var productsDirectory: URL {
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("Couldn't find products directory.")
    }

    func process(withArguments arguments: [String],
                 pipe: Pipe? = nil,
                 errorPipe: Pipe? = nil,
                 handler: ((Process) -> Void)? = nil) -> Process {
        let binary = Self.productsDirectory.appendingPathComponent("github-apps-token")
        let process = Process()
        process.executableURL = binary
        process.arguments = arguments
        handler?(process)
        process.standardOutput = pipe
        process.standardError = pipe
        process.standardError = errorPipe
        return process
    }
}
