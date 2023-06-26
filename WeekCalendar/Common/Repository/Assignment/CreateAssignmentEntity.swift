//
//  CreateAssignmentEntity.swift
//  HayEquipo
//
//  Created by David Gomez on 06/05/2023.
//

import Foundation

struct CreateAssignmentEntity {
    struct Input {
        let user: String
        let availability: String
        let status: String
        let startDate: String
        let amount: Double
        let item: String
    }
    
    struct Request: Encodable {
        let user: String
        let availability: String
        let status: String
        let startDate: String
        let amount: Double
        let item: String
    }
    
    struct Response: Decodable {
        
    }
}
