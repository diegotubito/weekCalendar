//
//  AssignmentRepository.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

typealias AssignmentResult = FetchAssignmentEntity.DateRange.Response
typealias AssignmentPastResult = FetchAssignmentEntity.Past.Response
typealias AssignmentFutureResult = FetchAssignmentEntity.Future.Response
typealias AssignmentAllResult = FetchAssignmentEntity.All.Response

protocol AssignmentRepositoryProtocol {
    func fetchAssignments(request: FetchAssignmentEntity.DateRange.Request) async throws -> AssignmentResult
    func fetchPastAssignments(request: FetchAssignmentEntity.Past.Request) async throws -> AssignmentPastResult
    func fetchFutureAssignments(request: FetchAssignmentEntity.Future.Request) async throws -> AssignmentFutureResult
    func fetchAllAssignments(request: FetchAssignmentEntity.All.Request) async throws -> AssignmentAllResult
    func fetchAllAssignmentsByUser(request: FetchAssignmentEntity.All.Request) async throws -> AssignmentAllResult
}

class AssignmentRepository: ApiNetworkAsync, AssignmentRepositoryProtocol {
    func fetchAllAssignments(request: FetchAssignmentEntity.All.Request) async throws -> AssignmentAllResult {
        config.path = "/assignment-all"
        config.addQueryItem(key: "spotId", value: request.spotId)
        config.method = .get
        return try await apiCall()
    }
    
    func fetchAllAssignmentsByUser(request: FetchAssignmentEntity.All.Request) async throws -> AssignmentAllResult {
        config.path = "/assignment-all-by-user"
        config.addQueryItem(key: "userId", value: request.spotId)
        config.method = .get
        return try await apiCall()
    }
    
    func fetchPastAssignments(request: FetchAssignmentEntity.Past.Request) async throws -> AssignmentPastResult {
        config.path = "/assignment-past"
        config.method = .get
        config.addQueryItem(key: "spotId", value: request.spotId)
        config.addQueryItem(key: "from", value: request.from)
        
        return try await apiCall()
    }
    
    func fetchFutureAssignments(request: FetchAssignmentEntity.Future.Request) async throws -> AssignmentFutureResult {
        config.path = "/assignment-future"
        config.method = .get
        config.addQueryItem(key: "spotId", value: request.spotId)
        config.addQueryItem(key: "from", value: request.from)
        
        return try await apiCall()
    }
    
    func fetchAssignments(request: FetchAssignmentEntity.DateRange.Request) async throws -> AssignmentResult {
        config.path = "/assignment"
        config.method = .get
        config.addQueryItem(key: "spotId", value: request.spotId)
        config.addQueryItem(key: "from", value: request.from)
        config.addQueryItem(key: "to", value: request.to)
        
        return try await apiCall()
    }
}

class AssignmentRepositoryMock: ApiNetworkMockAsync, AssignmentRepositoryProtocol {
    func fetchAllAssignmentsByUser(request: FetchAssignmentEntity.All.Request) async throws -> AssignmentAllResult {
        mockFileName = "assignment_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func fetchAllAssignments(request: FetchAssignmentEntity.All.Request) async throws -> AssignmentAllResult {
        mockFileName = "assignment_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func fetchPastAssignments(request: FetchAssignmentEntity.Past.Request) async throws -> AssignmentPastResult {
        mockFileName = "assignment_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func fetchFutureAssignments(request: FetchAssignmentEntity.Future.Request) async throws -> AssignmentFutureResult {
        mockFileName = "assignment_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func createAssignment(request: CreateAssignmentEntity.Request) async throws -> CreateAssignmentResult {
        mockFileName = "create_assignment_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func fetchAssignments(request: FetchAssignmentEntity.DateRange.Request) async throws -> AssignmentResult {
        mockFileName = "assignment_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class AssignmentRepositoryFactory {
    static func create() -> AssignmentRepositoryProtocol{
        let testing = ProcessInfo.processInfo.arguments.contains("XCODE_RUNNING_FOR_PREVIEWS")
        return testing ? AssignmentRepository() : AssignmentRepository()
    }
}

