//
//  AvailabilityModel.swift
//  HayEquipo
//
//  Created by David Gomez on 22/04/2023.
//

import Foundation

struct Availability: Decodable, Hashable {
    let _id: String
    let period: SchedulerCapsulePeriod
    let startDate: String
    let endDate: String
    let service: String
    let isEnabled: Bool
    let createdAt: String
    let updatedAt: String
}

struct AvailabilityModelPresenter: Hashable {
    let _id: String
    let period: SchedulerCapsulePeriod
    let startDate: String
    let endDate: String
    let service: String
    let isEnabled: Bool
    let createdAt: String
    let updatedAt: String
    
    var isScheduled: Bool = false
    var assignments: [Assignment] = []
}


extension AvailabilityModelPresenter {
    init(from model: Availability) {
        self._id = model._id
        self.period = model.period
        self.startDate = model.startDate
        self.endDate = model.endDate
        self.service = model.service
        self.isEnabled = model.isEnabled
        self.createdAt = model.createdAt
        self.updatedAt = model.updatedAt
    }
}


