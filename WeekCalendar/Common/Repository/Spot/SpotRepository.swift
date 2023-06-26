//
//  SpotRepository.swift
//  HayEquipo
//
//  Created by David Gomez on 09/04/2023.
//

import Foundation

typealias SpotResult = SpotEntity.Response

protocol SpotRepositoryProtocol {
    func fetchSpots(request: SpotEntity.Request) async throws -> SpotResult
    func fetchNearSpots(request: SpotEntity.NearSpotRequest) async throws -> SpotResult
}

class SpotRepository: ApiNetworkAsync, SpotRepositoryProtocol {
    func fetchSpots(request: SpotEntity.Request) async throws -> SpotResult {
        config.path = "/spot"
        config.method = .get
        
        return try await apiCall()
    }
    
    func fetchNearSpots(request: SpotEntity.NearSpotRequest) async throws -> SpotResult{
        config.path = "/near-spot"
        config.method = .post
        config.addRequestBody(request)
        return try await apiCall()
    }
}

class SpotRepositoryMock: ApiNetworkMockAsync, SpotRepositoryProtocol {
    func fetchNearSpots(request: SpotEntity.NearSpotRequest) async throws -> SpotResult {
        mockFileName = "spot_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func fetchSpots(request: SpotEntity.Request) async throws -> SpotResult {
        mockFileName = "spot_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class SpotRepositoryFactory {
    static func create() -> SpotRepositoryProtocol{
        let testing = ProcessInfo.processInfo.arguments.contains("XCODE_RUNNING_FOR_PREVIEWS")
        return testing ? SpotRepository() : SpotRepository()
    }
}
