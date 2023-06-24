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
    let capacity: Int
    let startDate: String
    let endDate: String
    let backgroundColor: Color
    let columnType: ColumnType
    
    enum ColumnType {
        case none
        case head
        case inner
        case tail
    }
}

enum SchedulerCapsulePeriod: String, Decodable {
    case none
    case daily
    case weekly
    case monthly
}

enum SheetType {
    case edit
    case new
    case none
}