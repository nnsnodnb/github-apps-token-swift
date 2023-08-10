//
//  PermissionTests.swift
//  
//
//  Created by Yuya Oka on 2023/08/10.
//

@testable import Entities
import Foundation
import XCTest

final class PermissionTests: XCTestCase {
    func testEncode() throws {
        let permission = Permission(
            actions: .write,
            administration: .write,
            checks: .write,
            contents: .write,
            deployments: .write,
            environments: .write,
            issues: .write,
            packages: .write,
            pages: .write,
            pullRequests: .write,
            repositoryAnnouncementBanners: .write,
            repositoryHooks: .write,
            repositoryProjects: .write,
            secretScanningAlerts: .write,
            secrets: .write,
            securityEvents: .write,
            singleFile: .write,
            statuses: .write,
            vulnerabilityAlerts: .write,
            workflows: .write,
            members: .write,
            organizationAdministration: .write,
            organizationCustomRoles: .write,
            organizationAnnouncementBanners: .write,
            organizationHooks: .write,
            organizationPlan: .write,
            organizationProjects: .write,
            organizationPackages: .write,
            organizationSecrets: .write,
            organizationSelfHostedRunners: .write,
            organizationUserBlocking: .write,
            teamDiscussions: .write
        )

        let jsonEncoder = JSONEncoder()
        let data = try jsonEncoder.encode(permission)
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: String] else {
            XCTFail("Invalid Permission encode")
            return
        }

        let permissions = [
            "actions",
            "administration",
            "checks",
            "contents",
            "deployments",
            "environments",
            "issues",
            "packages",
            "pages",
            "pull_requests",
            "repository_announcement_banners",
            "repository_hooks",
            "repository_projects",
            "secret_scanning_alerts",
            "secrets",
            "security_events",
            "single_file",
            "statuses",
            "vulnerability_alerts",
            "workflows",
            "members",
            "organization_administration",
            "organization_custom_roles",
            "organization_announcement_banners",
            "organization_hooks",
            "organization_plan",
            "organization_projects",
            "organization_packages",
            "organization_secrets",
            "organization_self_hosted_runners",
            "organization_user_blocking",
            "team_discussions"
         ]
        permissions.forEach {
            XCTAssertEqual(jsonObject[$0], "write", "\($0) is invalid.")
        }
    }
}
