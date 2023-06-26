//
//  ImageModel.swift
//  HayEquipo
//
//  Created by David Gomez on 16/04/2023.
//

import Foundation

struct ImageModel: Codable, Hashable {
    let _id: String
    let url: String
    let thumbnail: String?
}
