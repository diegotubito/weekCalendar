//
//  ItemUseCase.swift
//  HayEquipo
//
//  Created by David Gomez on 15/04/2023.
//

import Foundation

protocol ItemUseCaseProtocol {
    init(repository: ItemRepositoryProtocol)
    func fetchItems(input: ItemEntity.Input) async throws -> ItemResult
    func saveItem(input: ItemEntity.Create.Input) async throws -> ItemCreateResult
    func deleteItem(input: ItemEntity.Delete.Input) async throws -> ItemDeleteResult
    func updateItem(input: ItemEntity.Update.Input) async throws -> ItemUpdateResult
}

class ItemUseCase: ItemUseCaseProtocol {
    var repository: ItemRepositoryProtocol
    
    required init(repository: ItemRepositoryProtocol = ItemRepositoryFactory.create()) {
        self.repository = repository
    }
    
    func fetchItems(input: ItemEntity.Input) async throws -> ItemResult {
        let request = ItemEntity.Request(spotId: input.spotId)
        return try await repository.fetchItems(request: request)
    }
    
    func saveItem(input: ItemEntity.Create.Input) async throws -> ItemCreateResult {
        let request = ItemEntity.Create.Request(title: input.title,
                                                subtitle: input.subtitle,
                                                price: input.price,
                                                itemType: input.itemType,
                                                duration: input.duration,
                                                spot: input.spot,
                                                images: input.images)
        return try await repository.createItem(request: request)
    }
    
    func updateItem(input: ItemEntity.Update.Input) async throws -> ItemUpdateResult {
        let request = ItemEntity.Update.Request(_id: input._id,
                                                title: input.title,
                                                subtitle: input.subtitle,
                                                price: input.price,
                                                itemType: input.itemType,
                                                duration: input.duration,
                                                images: input.images)
        return try await repository.updateItem(request: request)
    }
    
    func deleteItem(input: ItemEntity.Delete.Input) async throws -> ItemDeleteResult {
        let request = ItemEntity.Delete.Request(_id: input._id)
        return try await repository.deleteItem(request: request)
    }
}
