//
//  AssignmentModel.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

struct Assignment: Decodable, Hashable {
    let _id: String
    let user: User
    let availability: Availability
    let item: Item
    let status: String
    let startDate: String
    let amount: Double
    let createdAt: String
    let updatedAt: String
    let expiration: Expiration?
    
    struct Expiration: Decodable, Hashable {
        let _id: String
        let duration: Int
        let startDate: String?
    }
}

enum AssignmentStatus: String {
    case userPending
    case ownerAccepted
    case ownerRejected
    case userScheduled
    case userCancelled
}
