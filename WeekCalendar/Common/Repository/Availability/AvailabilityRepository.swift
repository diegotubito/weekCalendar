//
//  AvailabilityRepository.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

typealias AvailabilityResult = AvailabilityEntity.Response
typealias AvailabilitySaveResult = AvailabilityEntity.Save.Response
typealias AvailabilityDeleteResult = AvailabilityEntity.Delete.Response
typealias AvailabilityUpdateResult = AvailabilityEntity.Update.Response

protocol AvailabilityRepositoryProtocol {
    func fetchAvailabilitys(request: AvailabilityEntity.Request) async throws -> AvailabilityResult
    func saveAvailability(request: AvailabilityEntity.Save.Request) async throws -> AvailabilitySaveResult
    func deleteAvailability(request: AvailabilityEntity.Delete.Request) async throws -> AvailabilityDeleteResult
    func updateAvailability(request: AvailabilityEntity.Update.Request) async throws -> AvailabilityUpdateResult
}

class AvailabilityRepository: ApiNetworkAsync, AvailabilityRepositoryProtocol {
    func saveAvailability(request: AvailabilityEntity.Save.Request) async throws -> AvailabilitySaveResult {
        config.path = "/availability"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
    
    func fetchAvailabilitys(request: AvailabilityEntity.Request) async throws -> AvailabilityResult {
        config.path = "/availability"
        config.method = .get
        config.addQueryItem(key: "serviceId", value: request.serviceId)
        
        return try await apiCall()
    }
    
    func deleteAvailability(request: AvailabilityEntity.Delete.Request) async throws -> AvailabilityDeleteResult {
        config.path = "/availability/\(request._id)"
        config.method = .delete
        
        return try await apiCall()
    }
    
    func updateAvailability(request: AvailabilityEntity.Update.Request) async throws -> AvailabilityUpdateResult {
        config.path = "/availability/\(request._id)"
        config.method = .put
        config.addRequestBody(request)

        return try await apiCall()
    }
}

class AvailabilityRepositoryMock: ApiNetworkMockAsync, AvailabilityRepositoryProtocol {
    func deleteAvailability(request: AvailabilityEntity.Delete.Request) async throws -> AvailabilityDeleteResult {
        mockFileName = "availability_mock_delete_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func saveAvailability(request: AvailabilityEntity.Save.Request) async throws -> AvailabilitySaveResult {
        mockFileName = "availability_mock_save_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func fetchAvailabilitys(request: AvailabilityEntity.Request) async throws -> AvailabilityResult {
        mockFileName = "availability_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func updateAvailability(request: AvailabilityEntity.Update.Request) async throws -> AvailabilityUpdateResult {
        mockFileName = "availability_mock_update_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class AvailabilityRepositoryFactory {
    static func create() -> AvailabilityRepositoryProtocol{
        let testing = ProcessInfo.processInfo.arguments.contains("XCODE_RUNNING_FOR_PREVIEWS")
        return testing ? AvailabilityRepository() : AvailabilityRepository()
    }
}

