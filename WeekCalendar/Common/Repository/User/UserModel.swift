//
//  UserModel.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

struct User: Codable, Hashable {
    let _id: String
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let isEnabled: Bool
    let role: String
    let phoneNumber: String
    let emailVerified: Bool
    let createdAt: String
    let spot: Spot?
}
