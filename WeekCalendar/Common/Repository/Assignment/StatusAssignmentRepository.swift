//
//  StatusAssignmentRepository.swift
//  HayEquipo
//
//  Statusd by David Gomez on 06/05/2023.
//

import Foundation

typealias StatusAssignmentResult = StatusAssignmentEntity.Response

protocol StatusAssignmentRepositoryProtocol {
    func acceptAssignment(request: StatusAssignmentEntity.Request) async throws -> StatusAssignmentResult
    func rejectAssignment(request: StatusAssignmentEntity.Request) async throws -> StatusAssignmentResult
    func scheduleAssignment(request: StatusAssignmentEntity.Request) async throws -> StatusAssignmentResult
    func cancelAssignment(request: StatusAssignmentEntity.Request) async throws -> StatusAssignmentResult
}

class StatusAssignmentRepository: ApiNetworkAsync, StatusAssignmentRepositoryProtocol {
    func acceptAssignment(request: StatusAssignmentEntity.Request) async throws -> StatusAssignmentResult {
        config.path = "/assignment/accept"
        config.method = .post
        config.addRequestBody(request)
        return try await apiCall()
    }
    
    func rejectAssignment(request: StatusAssignmentEntity.Request) async throws -> StatusAssignmentResult {
        config.path = "/assignment/reject/\(request.assignmentId)"
        config.method = .post
        return try await apiCall()
    }
    
    func scheduleAssignment(request: StatusAssignmentEntity.Request) async throws -> StatusAssignmentResult {
        config.path = "/assignment/schedule/\(request.assignmentId)"
        config.method = .post
        return try await apiCall()
    }
    
    func cancelAssignment(request: StatusAssignmentEntity.Request) async throws -> StatusAssignmentResult {
        config.path = "/assignment/cancel/\(request.assignmentId)"
        config.method = .post
        return try await apiCall()
    }
}

class StatusAssignmentRepositoryFactory {
    static func Status() -> StatusAssignmentRepositoryProtocol {
        let testing = ProcessInfo.processInfo.arguments.contains("XCODE_RUNNING_FOR_PREVIEWS")
        return testing ? StatusAssignmentRepository() : StatusAssignmentRepository()
    }
}


