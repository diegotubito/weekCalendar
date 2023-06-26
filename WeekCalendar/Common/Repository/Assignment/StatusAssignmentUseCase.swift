//
//  StatusAssignmentUseCase.swift
//  HayEquipo
//
//  Statusd by David Gomez on 06/05/2023.
//

import Foundation

protocol StatusAssignmentUseCaseProtocol {
    init(repository: StatusAssignmentRepositoryProtocol)
    func acceptAssignment(input: StatusAssignmentEntity.Input) async throws -> StatusAssignmentResult
    func rejectAssignment(input: StatusAssignmentEntity.Input) async throws -> StatusAssignmentResult
    func scheduleAssignment(input: StatusAssignmentEntity.Input) async throws -> StatusAssignmentResult
    func cancelAssignment(input: StatusAssignmentEntity.Input) async throws -> StatusAssignmentResult
}

class StatusAssignmentUseCase: StatusAssignmentUseCaseProtocol {
   
    var repository: StatusAssignmentRepositoryProtocol
    
    required init(repository: StatusAssignmentRepositoryProtocol = StatusAssignmentRepositoryFactory.Status()) {
        self.repository = repository
    }
    
    func acceptAssignment(input: StatusAssignmentEntity.Input) async throws -> StatusAssignmentResult {
        let request = StatusAssignmentEntity.Request(assignmentId: input.assignmentId, startDate: input.startDate, availabilityId: input.availabilityId)
        return try await repository.acceptAssignment(request: request)
    }

    func rejectAssignment(input: StatusAssignmentEntity.Input) async throws -> StatusAssignmentResult {
        let request = StatusAssignmentEntity.Request(assignmentId: input.assignmentId, startDate: input.startDate, availabilityId: input.availabilityId)
        return try await repository.rejectAssignment(request: request)
    }
    
    func scheduleAssignment(input: StatusAssignmentEntity.Input) async throws -> StatusAssignmentResult {
        let request = StatusAssignmentEntity.Request(assignmentId: input.assignmentId, startDate: input.startDate, availabilityId: input.availabilityId)
        return try await repository.scheduleAssignment(request: request)
    }
    
    func cancelAssignment(input: StatusAssignmentEntity.Input) async throws -> StatusAssignmentResult {
        let request = StatusAssignmentEntity.Request(assignmentId: input.assignmentId, startDate: input.startDate, availabilityId: input.availabilityId)
        return try await repository.cancelAssignment(request: request)
    }
}


