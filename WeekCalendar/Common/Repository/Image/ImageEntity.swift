//
//  ImageEntity.swift
//  HayEquipo
//
//  Created by David Gomez on 17/04/2023.
//

import Foundation

struct ImageEntity {
    struct Input {
        let url: String
    }
    
    struct Request: Encodable {
        let url: String
    }
    
    struct Response: Decodable {
        let imageData: Data
    }
}
