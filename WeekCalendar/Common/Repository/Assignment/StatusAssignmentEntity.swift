//
//  StatusAssignmentEntity.swift
//  HayEquipo
//
//  Created by David Gomez on 06/05/2023.
//

import Foundation

struct StatusAssignmentEntity {
    struct Input {
        let assignmentId: String
        let startDate: String
        let availabilityId: String
    }

    struct Request: Codable {
        let assignmentId: String
        let startDate: String
        let availabilityId: String
    }    
    
    struct Response: Decodable {
        let assignment: Assignment
    }
}
