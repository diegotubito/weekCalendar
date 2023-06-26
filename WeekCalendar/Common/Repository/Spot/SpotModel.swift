//
//  SpotModel.swift
//  HayEquipo
//
//  Created by David Gomez on 09/04/2023.
//

import Foundation

struct Spot: Codable, Hashable {
    let _id: String
    let title: String
    let subtitle: String
    let thumbnailImage: String?
    let profileImage: String?
    let images: [ImageModel]
    let isEnabled: Bool
    
    let location: Location
    let contactInformation: ContactInformation
    let tipos: [Tipo]
    
    struct Location: Codable, Hashable {
        let _id: String
        let coordinates: [Double]
        let street: String
        let streetNumber: Int
        let cp: String
        let locality: String
        let state: String
        let country: String
    }

    struct ContactInformation: Codable, Hashable {
        let phoneNumber: String
        let email: String
    }

    struct Tipo: Codable, Hashable {
        let _id: String
        let type: String
        let icon: String
        let tintColor: String
    }
}
