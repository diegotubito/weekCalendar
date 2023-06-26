//
//  ItemModel.swift
//  HayEquipo
//
//  Created by David Gomez on 15/04/2023.
//

import SwiftUI

struct Item: Decodable, Hashable {
    let _id: String
    let title: String
    let subtitle: String
    let itemType: String
    let price: Double
    let isEnabled: Bool
    let spot: Spot
    let createdAt: String
    let updatedAt: String
    let images: [ImageModel]
}

enum ItemType: String, Decodable, Hashable  {
    case service
    case product
}

struct ItemModelPresenter: Hashable {
    let _id: String
    let title: String
    let subtitle: String
    let itemType: String
    let price: Double
    let isEnabled: Bool
    let spot: String
    let createdAt: String
    let updatedAt: String
    let images: [ImageModel]
    
    var image: UIImage
    var imageState: ImageState
    var availabilities: [AvailabilityModelPresenter]
    var availabilitiesState: AvailabilityState
    
    enum ImageState {
        case idle
        case loading
        case loaded
        case failed
    }
    
    enum AvailabilityState: String {
        case idle
        case loading
        case loaded
        case failed
        case cancelled
    }
}

extension ItemModelPresenter {
    init(from model: Item) {
        self._id = model._id
        self.title = model.title
        self.subtitle = model.subtitle
        self.itemType = model.itemType
        self.price = model.price
        self.isEnabled = model.isEnabled
        self.spot = model.spot._id
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
        self.image = UIImage(systemName: "pencil")!
        self.imageState = .idle
        self.images = model.images
        self.availabilities = []
        self.availabilitiesState = .idle
    }
}
