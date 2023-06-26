//
//  ItemEntity.swift
//  HayEquipo
//
//  Created by David Gomez on 15/04/2023.
//

import Foundation

struct ItemEntity {
    struct Input {
        let spotId: String
    }
    struct Request {
        let spotId: String
    }

    struct Response: Decodable {
        let count: Int?
        let items: [Item]
    }
    
    struct Delete {
        struct Input {
            let _id: String
        }
        
        struct Request {
            let _id: String
        }
    }
    
    struct Create {
        struct Input {
            let title: String
            let subtitle: String
            let price: Double
            let itemType: String
            let duration: Int
            let spot: String
            let images: [ImageModel]
        }
        
        struct Request: Codable {
            let title: String
            let subtitle: String
            let price: Double
            let itemType: String
            let duration: Int
            let spot: String
            let images: [ImageModel]
        }
    }
    
    struct Update {
        struct Input {
            let _id: String
            let title: String
            let subtitle: String
            let price: Double
            let itemType: String
            let duration: Int
            let images: [ImageModel]
        }
        
        struct Request: Codable {
            let _id: String
            let title: String
            let subtitle: String
            let price: Double
            let itemType: String
            let duration: Int
            let images: [ImageModel]
        }
    }
}
