//
//  Typealiases.swift
//  
//
//  Created by Yuya Oka on 2023/02/14.
//

import Foundation
import Tagged

// MARK: - JWT
public typealias JWT = Tagged<(String, jwt: ()), String>

// MARK: - Repository
public typealias Repository = Tagged<(String, repository: ()), String>

// MARK: - Repositories
public typealias Repositories = Tagged<([Repository], repositories: ()), [Repository]>
