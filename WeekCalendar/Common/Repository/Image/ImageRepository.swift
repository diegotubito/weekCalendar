//
//  ImageRepository.swift
//  HayEquipo
//
//  Created by David Gomez on 17/04/2023.
//

import Foundation

typealias ImageResult = Data

protocol ImageRepositoryProtocol {
    func fetchImages(request: ImageEntity.Request) async throws -> ImageResult
}

class ImageRepository: ApiNetworkAsync, ImageRepositoryProtocol {
    func fetchImages(request: ImageEntity.Request) async throws -> ImageResult {
        config.path = "/image"
        config.method = .post
        config.addRequestBody(request)
        
        return try await apiCall()
    }
}

class ImageRepositoryMock: ApiNetworkMockAsync, ImageRepositoryProtocol {
    func fetchImages(request: ImageEntity.Request) async throws -> ImageResult {
        mockFileName = "Image_mock_response"
        return try await apiCallMocked(bundle: Bundle.main)
    }
}

class ImageRepositoryFactory {
    static func create() -> ImageRepositoryProtocol{
        let testing = ProcessInfo.processInfo.arguments.contains("XCODE_RUNNING_FOR_PREVIEWS")
        return testing ? ImageRepository() : ImageRepository()
    }
}

