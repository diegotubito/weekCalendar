//
//  AssignmentUseCase.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

protocol AssignmentUseCaseProtocol {
    init(repository: AssignmentRepositoryProtocol)
    func fetchAssignments(input: FetchAssignmentEntity.DateRange.Input) async throws -> AssignmentResult
    func fetchPastAssignments(input: FetchAssignmentEntity.Past.Input) async throws -> AssignmentPastResult
    func fetchFutureAssignments(input: FetchAssignmentEntity.Future.Input) async throws -> AssignmentFutureResult
    func fetchAllAssignments(input: FetchAssignmentEntity.All.Input) async throws -> AssignmentAllResult
    func fetchAllAssignmentsByUser(input: FetchAssignmentEntity.All.Input) async throws -> AssignmentAllResult
}

class AssignmentUseCase: AssignmentUseCaseProtocol {
   
    var repository: AssignmentRepositoryProtocol
    
    required init(repository: AssignmentRepositoryProtocol = AssignmentRepositoryFactory.create()) {
        self.repository = repository
    }
    
    func fetchAssignments(input: FetchAssignmentEntity.DateRange.Input) async throws -> AssignmentResult {
        let request = FetchAssignmentEntity.DateRange.Request(spotId: input.spotId, from: input.from, to: input.to)
        return try await repository.fetchAssignments(request: request)
    }

    func fetchPastAssignments(input: FetchAssignmentEntity.Past.Input) async throws -> AssignmentPastResult {
        let request = FetchAssignmentEntity.Past.Request(spotId: input.spotId, from: input.from)
        return try await repository.fetchPastAssignments(request: request)
    }
    
    func fetchFutureAssignments(input: FetchAssignmentEntity.Future.Input) async throws -> AssignmentFutureResult {
        let request = FetchAssignmentEntity.Future.Request(spotId: input.spotId, from: input.from)
        return try await repository.fetchFutureAssignments(request: request)
    }

    func fetchAllAssignments(input: FetchAssignmentEntity.All.Input) async throws -> AssignmentAllResult {
        let request = FetchAssignmentEntity.All.Request(spotId: input.spotId)
        return try await repository.fetchAllAssignments(request: request)
    }

    func fetchAllAssignmentsByUser(input: FetchAssignmentEntity.All.Input) async throws -> AssignmentAllResult {
        let request = FetchAssignmentEntity.All.Request(spotId: input.spotId)
        return try await repository.fetchAllAssignmentsByUser(request: request)
    }
}

