//
//  AssignmentEntity.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

struct FetchAssignmentEntity {
    struct Future {
        struct Input {
            let spotId: String
            let from: String
        }
        struct Request {
            let spotId: String
            let from: String
        }

        struct Response: Decodable {
            let count: Int?
            let assignments: [Assignment]
        }
    }
    
    struct Past {
        struct Input {
            let spotId: String
            let from: String
        }
        struct Request {
            let spotId: String
            let from: String
        }

        struct Response: Decodable {
            let count: Int?
            let assignments: [Assignment]
        }
    }
    
    struct DateRange {
        struct Input {
            let spotId: String
            let from: String
            let to: String
        }
        struct Request {
            let spotId: String
            let from: String
            let to: String
        }

        struct Response: Decodable {
            let count: Int?
            let assignments: [Assignment]
        }
    }
    
    struct All {
        struct Input {
            let spotId: String
        }
        struct Request {
            let spotId: String
        }

        struct Response: Decodable {
            let count: Int?
            let assignments: [Assignment]
        }
    }
}
