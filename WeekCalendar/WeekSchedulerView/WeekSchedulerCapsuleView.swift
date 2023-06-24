//
//  WeekSchedulerCapsuleView.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

struct WeekSchedulerCapsuleView: View {
    var capsule: WeekSchedulerView.SchedulerModel
    
    var body: some View {
        VStack(spacing: 0) {
            if capsule.columnType == .inner || capsule.columnType == .tail {
                HStack {
                    Text("⤵")
                    Spacer()
                }
            }
            HStack {
                Text("\(getStartTime(stringDate: capsule.startDate)) (\(capsule.capacity))")
                    .font(.system(size: 10))
                    .padding(.horizontal, 4)
                    .foregroundColor(.white.opacity(0.5))
                Spacer()
            }
            Spacer()
//            HStack {
//                Text(getEndTime(stringDate: capsule.endDate))
//                    .font(.system(size: 9))
//                    .padding(.horizontal, 4)
//                    .foregroundColor(.white.opacity(0.5))
//                Spacer()
//            }
            if capsule.columnType == .inner || capsule.columnType == .head {
                HStack {
                    Spacer()
                    Text("⤴")
                }
            }
        }
        
    }
    
    func getStartTime(stringDate: String) -> String {
        stringDate.showTimeFormat()
    }
    
    func getEndTime(stringDate: String) -> String {
        stringDate.showTimeFormat()
    }
}
