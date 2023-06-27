//
//  WeekSchedulerModel.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

struct SchedulerCapsuleModel: Hashable {
    let availabilityId: String
    let period: SchedulerCapsulePeriod
    let startDate: String
    let endDate: String
    let backgroundColor: Color
    let columnType: ColumnType
    let expiration: String?
    
    enum ColumnType {
        case none
        case head
        case inner
        case tail
    }
}

enum SchedulerCapsulePeriod: String, Decodable, CaseIterable {
    case oneTime = "one time"
    case daily
    case weekly
    case monthly
    case weekend
    case business = "business days"
    case workingDays = "working days"
}

enum SheetType: Equatable {
    case edit
    case new
}
