//
//  Permission.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation

public struct Permission: Encodable {
    // MARK: - Properties
    public let actions: Level?
    public let administration: Level?
    public let checks: Level?
    public let contents: Level?
    public let deployments: Level?
    public let environments: Level?
    public let issues: Level?
    public let packages: Level?
    public let pages: Level?
    public let pullRequests: Level?
    public let repositoryAnnouncementBanners: Level?
    public let repositoryHooks: Level?
    public let repositoryProjects: Level?
    public let secretScanningAlerts: Level?
    public let secrets: Level?
    public let securityEvents: Level?
    public let singleFile: Level?
    public let statuses: Level?
    public let vulnerabilityAlerts: Level?
    public let workflows: Level?
    public let members: Level?
    public let organizationAdministration: Level?
    public let organizationCustomRoles: Level?
    public let organizationAnnouncementBanners: Level?
    public let organizationHooks: Level?
    public let organizationPlan: Level?
    public let organizationProjects: Level?
    public let organizationPackages: Level?
    public let organizationSecrets: Level?
    public let organizationSelfHostedRunners: Level?
    public let organizationUserBlocking: Level?
    public let teamDiscussions: Level?

    // MARK: - Initialize
    public init(
        actions: Level? = nil,
        administration: Level? = nil,
        checks: Level? = nil,
        contents: Level? = nil,
        deployments: Level? = nil,
        environments: Level? = nil,
        issues: Level? = nil,
        packages: Level? = nil,
        pages: Level? = nil,
        pullRequests: Level? = nil,
        repositoryAnnouncementBanners: Level? = nil,
        repositoryHooks: Level? = nil,
        repositoryProjects: Level? = nil,
        secretScanningAlerts: Level? = nil,
        secrets: Level? = nil,
        securityEvents: Level? = nil,
        singleFile: Level? = nil,
        statuses: Level? = nil,
        vulnerabilityAlerts: Level? = nil,
        workflows: Level? = nil,
        members: Level? = nil,
        organizationAdministration: Level? = nil,
        organizationCustomRoles: Level? = nil,
        organizationAnnouncementBanners: Level? = nil,
        organizationHooks: Level? = nil,
        organizationPlan: Level? = nil,
        organizationProjects: Level? = nil,
        organizationPackages: Level? = nil,
        organizationSecrets: Level? = nil,
        organizationSelfHostedRunners: Level? = nil,
        organizationUserBlocking: Level? = nil,
        teamDiscussions: Level? = nil
    ) {
        self.actions = actions
        self.administration = administration
        self.checks = checks
        self.contents = contents
        self.deployments = deployments
        self.environments = environments
        self.issues = issues
        self.packages = packages
        self.pages = pages
        self.pullRequests = pullRequests
        self.repositoryAnnouncementBanners = repositoryAnnouncementBanners
        self.repositoryHooks = repositoryHooks
        self.repositoryProjects = repositoryProjects
        self.secretScanningAlerts = secretScanningAlerts
        self.secrets = secrets
        self.securityEvents = securityEvents
        self.singleFile = singleFile
        self.statuses = statuses
        self.vulnerabilityAlerts = vulnerabilityAlerts
        self.workflows = workflows
        self.members = members
        self.organizationAdministration = organizationAdministration
        self.organizationCustomRoles = organizationCustomRoles
        self.organizationAnnouncementBanners = organizationAnnouncementBanners
        self.organizationHooks = organizationHooks
        self.organizationPlan = organizationPlan
        self.organizationProjects = organizationProjects
        self.organizationPackages = organizationPackages
        self.organizationSecrets = organizationSecrets
        self.organizationSelfHostedRunners = organizationSelfHostedRunners
        self.organizationUserBlocking = organizationUserBlocking
        self.teamDiscussions = teamDiscussions
    }

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case actions
        case administration
        case checks
        case contents
        case deployments
        case environments
        case issues
        case packages
        case pages
        case pullRequests = "pull_requests"
        case repositoryAnnouncementBanners = "repository_announcement_banners"
        case repositoryHooks = "repository_hooks"
        case repositoryProjects = "repository_projects"
        case secretScanningAlerts = "secret_scanning_alerts"
        case secrets
        case securityEvents = "security_events"
        case singleFile = "single_file"
        case statuses
        case vulnerabilityAlerts = "vulnerability_alerts"
        case workflows
        case members
        case organizationAdministration = "organization_administration"
        case organizationCustomRoles = "organization_custom_roles"
        case organizationAnnouncementBanners = "organization_announcement_banners"
        case organizationHooks = "organization_hooks"
        case organizationPlan = "organization_plan"
        case organizationProjects = "organization_projects"
        case organizationPackages = "organization_packages"
        case organizationSecrets = "organization_secrets"
        case organizationSelfHostedRunners = "organization_self_hosted_runners"
        case organizationUserBlocking = "organization_user_blocking"
        case teamDiscussions = "team_discussions"
    }
}

// MARK: - Level
public extension Permission {
    enum Level: String, Encodable {
        case read
        case write
        case admin

        // MARK: - Initialize
        public init(rawValue: String, withoutAdmin: Bool) throws {
            switch rawValue {
            case "read":
                self = .read
            case "write":
                self = .write
            case "admin" where !withoutAdmin:
                self = .admin
            default:
                throw Error.unknwon
            }
        }
    }
}

// MARK: - Level.Error
extension Permission.Level {
    enum Error: Swift.Error {
        case unknwon
    }
}
