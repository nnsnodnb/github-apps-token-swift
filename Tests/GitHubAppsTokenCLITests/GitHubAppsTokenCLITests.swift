//
//  GitHubAppsTokenCLITests.swift
//
//
//  Created by Yuya Oka on 2023/02/16.
//

import ArgumentParser
import Foundation
@testable import GitHubAppsTokenCore
import Testing

struct GitHubAppsTokenCLITests {
    @Test
    func testVersion() throws {
        let pipe = Pipe()
        let process = process(
            withArguments: ["--version"],
            pipe: pipe
        )

        #expect(throws: Never.self) {
          try process.run()
        }
        process.waitUntilExit()
        #expect(ExitCode(process.terminationStatus) == .success)

        guard let version = pipe.readStandardOutput() else {
          Issue.record("version is not found")
          return
        }

        #expect(version == Runner.version)
    }
}

// MARK: - Private
private extension GitHubAppsTokenCLITests {
    static var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
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
