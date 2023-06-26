//
//  SpotEntity.swift
//  HayEquipo
//
//  Created by David Gomez on 09/04/2023.
//

import Foundation

struct SpotEntity {
    struct Input {
        let coordinates: [Double]
        let distance: Double
    }
    
    struct Request {
      
    }

    struct NearSpotRequest: Encodable {
        let coordinates: [Double]
        let distance: Double
    }

    struct Response: Decodable {
        let count: Int?
        let spots: [Spot]
    }
}
