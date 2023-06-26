//
//  ItemRepository.swift
//  HayEquipo
//
//  Created by David Gomez on 15/04/2023.
//

import Foundation

typealias ItemResult = ItemEntity.Response
typealias ItemCreateResult = Data
typealias ItemDeleteResult = Data
typealias ItemUpdateResult = Data

protocol ItemRepositoryProtocol {
    func fetchItems(request: ItemEntity.Request) async throws -> ItemResult
    func createItem(request: ItemEntity.Create.Request) async throws -> ItemCreateResult
    func deleteItem(request: ItemEntity.Delete.Request) async throws -> ItemDeleteResult
    func updateItem(request: ItemEntity.Update.Request) async throws -> ItemUpdateResult
}

class ItemRepository: ApiNetworkAsync, ItemRepositoryProtocol {
    func fetchItems(request: ItemEntity.Request) async throws -> ItemResult {
        config.path = "/item"
        config.method = .get
        config.addQueryItem(key: "spotId", value: request.spotId)
        
        return try await apiCall()
    }
    
    func createItem(request: ItemEntity.Create.Request) async throws -> ItemCreateResult {
        config.path = "/item"
        config.method = .post
        config.addRequestBody(request)
        return try await apiCall()
    }
    
    func updateItem(request: ItemEntity.Update.Request) async throws -> ItemUpdateResult {
        config.path = "/item/\(request._id)"
        config.method = .put
        config.addRequestBody(request)
        return try await apiCall()
    }
    
    func deleteItem(request: ItemEntity.Delete.Request) async throws -> ItemDeleteResult {
        config.path = "/item/\(request._id)"
        config.method = .delete
        return try await apiCall()
    }
}

class ItemRepositoryMock: ApiNetworkMockAsync, ItemRepositoryProtocol {
    
    func updateItem(request: ItemEntity.Update.Request) async throws -> ItemUpdateResult {
        mockFileName = "update_item_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    func deleteItem(request: ItemEntity.Delete.Request) async throws -> ItemDeleteResult {
        mockFileName = "delete_item_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func createItem(request: ItemEntity.Create.Request) async throws -> ItemCreateResult {
        mockFileName = "create_item_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
    
    func fetchItems(request: ItemEntity.Request) async throws -> ItemResult {
        mockFileName = "item_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class ItemRepositoryFactory {
    static func create() -> ItemRepositoryProtocol{
        let testing = ProcessInfo.processInfo.arguments.contains("XCODE_RUNNING_FOR_PREVIEWS")
        return testing ? ItemRepository() : ItemRepository()
    }
}

