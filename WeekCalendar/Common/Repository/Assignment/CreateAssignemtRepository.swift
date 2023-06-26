//
//  CreateAssignemtRepository.swift
//  HayEquipo
//
//  Created by David Gomez on 06/05/2023.
//

import Foundation

typealias CreateAssignmentResult = Data

protocol CreateAssignmentRepositoryProtocol {
    func createAssignment(request: CreateAssignmentEntity.Request) async throws -> CreateAssignmentResult
}

class CreateAssignmentRepository: ApiNetworkAsync, CreateAssignmentRepositoryProtocol {
    func createAssignment(request: CreateAssignmentEntity.Request) async throws -> CreateAssignmentResult {
        config.path = "/assignment"
        config.method = .post
        config.addRequestBody(request)
        return try await apiCall()
    }
}

class CreateAssignmentRepositoryMock: ApiNetworkMockAsync, CreateAssignmentRepositoryProtocol {
    func createAssignment(request: CreateAssignmentEntity.Request) async throws -> CreateAssignmentResult {
        mockFileName = "create_assignment_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class CreateAssignmentRepositoryFactory {
    static func create() -> CreateAssignmentRepositoryProtocol {
        let testing = ProcessInfo.processInfo.arguments.contains("XCODE_RUNNING_FOR_PREVIEWS")
        return testing ? CreateAssignmentRepository() : CreateAssignmentRepository()
    }
}


