//
//  GitHubAppsTokenCLITests.swift
//
//
//  Created by Yuya Oka on 2023/02/16.
//

import ArgumentParser
@testable import CreateCore
import XCTest

final class GitHubAppsTokenCLITests: XCTestCase {
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

        XCTAssertEqual(version, CreateCore.version)
    }
}

// MARK: - Private
private extension GitHubAppsTokenCLITests {
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
