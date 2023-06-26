//
//  ImageUseCase.swift
//  HayEquipo
//
//  Created by David Gomez on 17/04/2023.
//

import Foundation

protocol ImageUseCaseProtocol {
    init(repository: ImageRepositoryProtocol)
    func fetchImages(input: ImageEntity.Input) async throws -> ImageResult
}

class ImageUseCase: ImageUseCaseProtocol {
    var repository: ImageRepositoryProtocol
    
    required init(repository: ImageRepositoryProtocol = ImageRepositoryFactory.create()) {
        self.repository = repository
    }
    
    func fetchImages(input: ImageEntity.Input) async throws -> ImageResult {
        let request = ImageEntity.Request(url: input.url)
        return try await repository.fetchImages(request: request)
    }
}
