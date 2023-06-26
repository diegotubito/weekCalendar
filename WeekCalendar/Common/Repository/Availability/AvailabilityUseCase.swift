//
//  AvailabilityUseCase.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

protocol AvailabilityUseCaseProtocol {
    init(repository: AvailabilityRepositoryProtocol)
    func fetchAvailabilities(input: AvailabilityEntity.Input) async throws -> AvailabilityResult
    func saveAvailability(input: AvailabilityEntity.Save.Input) async throws -> AvailabilitySaveResult
    func deleteAvailability(input: AvailabilityEntity.Delete.Input) async throws -> AvailabilityDeleteResult
    func updateAvailability(input: AvailabilityEntity.Update.Input) async throws -> AvailabilityUpdateResult
}

class AvailabilityUseCase: AvailabilityUseCaseProtocol {
    var repository: AvailabilityRepositoryProtocol
    
    required init(repository: AvailabilityRepositoryProtocol = AvailabilityRepositoryFactory.create()) {
        self.repository = repository
    }
    
    func fetchAvailabilities(input: AvailabilityEntity.Input) async throws -> AvailabilityResult {
        let request = AvailabilityEntity.Request(serviceId: input.serviceId)
        return try await repository.fetchAvailabilitys(request: request)
    }
    
    func saveAvailability(input: AvailabilityEntity.Save.Input) async throws -> AvailabilitySaveResult {
        let request = AvailabilityEntity.Save.Request(service: input.service, startDate: input.startDate, endDate: input.endDate, period: input.period, expiration: input.expiration)
        return try await repository.saveAvailability(request: request)
    }
    
    func deleteAvailability(input: AvailabilityEntity.Delete.Input) async throws -> AvailabilityDeleteResult {
        let request = AvailabilityEntity.Delete.Request(_id: input._id)
        return try await repository.deleteAvailability(request: request)
    }
    
    func updateAvailability(input: AvailabilityEntity.Update.Input) async throws -> AvailabilityUpdateResult {
        let request = AvailabilityEntity.Update.Request(_id: input._id, startDate: input.startDate, endDate: input.endDate, period: input.period, expiration: input.expiration)
        return try await repository.updateAvailability(request: request)
    }
}

