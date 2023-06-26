//
//  AvailabilityEntity.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

struct AvailabilityEntity {
    struct Input {
        let serviceId: String
    }
    struct Request {
        let serviceId: String
    }

    struct Response: Decodable {
        let count: Int?
        let availabilities: [Availability]
    }
    
    struct Save {
        struct Input {
            let service: String
            let startDate: String
            let endDate: String
            let period: String
        }
        
        struct Request: Encodable {
            let service: String
            let startDate: String
            let endDate: String
            let period: String
        }

        struct Response: Decodable {
            let availability: Availability
        }
    }
    
    struct Delete {
        struct Input {
            let _id: String
        }
        
        struct Request: Encodable {
            let _id: String
        }

        struct Response: Decodable {
            let availability: Availability
        }
    }
    
    struct Update {
        struct Input {
            let _id: String
            let startDate: String
            let endDate: String
            let period: String
        }
        
        struct Request: Encodable {
            let _id: String
            let startDate: String
            let endDate: String
            let period: String
        }

        struct Response: Decodable {
            let availability: Availability
        }
    }
}

