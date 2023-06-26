//
//  LoginRepository.swift
//  HayEquipo
//
//  Created by David Gomez on 15/04/2023.
//

import Foundation

typealias LoginResult = LoginEntity.Response

protocol LoginRepositoryProtocol {
    func doLogin(request: LoginEntity.Request) async throws -> LoginResult
}

class LoginRepository: ApiNetworkAsync, LoginRepositoryProtocol {
    func doLogin(request: LoginEntity.Request) async throws -> LoginResult {
        config.userIsNeeded = false
        config.path = "/api/v1/auth/login"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
}

class LoginRepositoryMock: ApiNetworkMockAsync, LoginRepositoryProtocol {
    func doLogin(request: LoginEntity.Request) async throws -> LoginResult {
        mockFileName = "login_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class LoginRepositoryFactory {
    static func create() -> LoginRepositoryProtocol{
        let testing = ProcessInfo.processInfo.arguments.contains("XCODE_RUNNING_FOR_PREVIEWS")
        return testing ? LoginRepository() : LoginRepository()
    }
}

