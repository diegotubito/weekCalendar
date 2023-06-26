//
//  SpotUseCase.swift
//  HayEquipo
//
//  Created by David Gomez on 09/04/2023.
//

import Foundation

protocol SpotUseCaseProtocol {
    init(repository: SpotRepositoryProtocol)
    func fetchSpots(input: SpotEntity.Input) async throws -> SpotResult
    func fetchNearSpots(input: SpotEntity.Input) async throws -> SpotResult
}

class SpotUseCase: SpotUseCaseProtocol {
    var repository: SpotRepositoryProtocol
    
    required init(repository: SpotRepositoryProtocol = SpotRepositoryFactory.create()) {
        self.repository = repository
    }
    
    func fetchSpots(input: SpotEntity.Input) async throws -> SpotResult {
        let request = SpotEntity.Request()
        return try await repository.fetchSpots(request: request)
    }
    
    func fetchNearSpots(input: SpotEntity.Input) async throws -> SpotResult{
        let request = SpotEntity.NearSpotRequest(coordinates: input.coordinates, distance: input.distance)
        return try await repository.fetchNearSpots(request: request)
    }
}
