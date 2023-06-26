//
//  CreateAssignmentUseCase.swift
//  HayEquipo
//
//  Created by David Gomez on 06/05/2023.
//

import Foundation

protocol CreateAssignmentUseCaseProtocol {
    init(repository: CreateAssignmentRepositoryProtocol)
    func createAssignment(input: CreateAssignmentEntity.Input) async throws -> CreateAssignmentResult
}

class CreateAssignmentUseCase: CreateAssignmentUseCaseProtocol {
   
    var repository: CreateAssignmentRepositoryProtocol
    
    required init(repository: CreateAssignmentRepositoryProtocol = CreateAssignmentRepositoryFactory.create()) {
        self.repository = repository
    }
    
    func createAssignment(input: CreateAssignmentEntity.Input) async throws -> CreateAssignmentResult {
        let request = CreateAssignmentEntity.Request(user: input.user,
                                                     availability: input.availability,
                                                     status: input.status,
                                                     startDate: input.startDate,
                                                     amount: input.amount,
                                                     item: input.item)
        return try await repository.createAssignment(request: request)
    }
}

