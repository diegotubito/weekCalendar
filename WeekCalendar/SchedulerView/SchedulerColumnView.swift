//
//  AvailabilitySheet.swift
//  CustomView
//
//  Created by David Gomez on 17/06/2023.
//

import SwiftUI

struct SchedulerColumnView: View {
    var items: [SchedulerModel]
    var hours = Array(0..<Int(SchedulerView.Constant.maxHours))
    
    var itemDidTapped: ((SchedulerModel) -> Void)?
    var emptyHourDidTapped: ((Int?) -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: SchedulerView.Constant.spacing) {
                    ForEach(hours, id: \.self) { hour in
                        ZStack {
                            Color.gray.opacity(0.25).frame(height: SchedulerView.Constant.hourHeight)
                                .onTapGesture {
                                    emptyHourDidTapped?(hours.firstIndex(of: hour))
                                }
                        }
                    }
                }
               
                ZStack {
                    ForEach(items, id: \.self) { item in
                        SchedulerCapsuleView(item: item)
                            .frame(width: geometry.size.width * SchedulerView.Constant.widthProportional,
                                   height: getItemHeight(item: item))
                            .background(item.backgroundColor)
                            .cornerRadius(SchedulerView.Constant.cornerRadius)
                            .position(x: ((geometry.size.width * SchedulerView.Constant.widthProportional) / 2) + ((geometry.size.width * (1 - SchedulerView.Constant.widthProportional)) / 2),
                                      y: getPosition(item: item))
                            .onTapGesture {
                                itemDidTapped?(item)
                            }
                    }
                }
            }
        }
    }
    
    func getItemHeight(item: SchedulerModel) -> CGFloat {
        return getTimeInterval(item: item) * (SchedulerView.Constant.hourHeight) + (getTimeInterval(item: item) * SchedulerView.Constant.spacing) - (SchedulerView.Constant.spacing * 2)
    }
    
    func getZeroPosition(item: SchedulerModel) -> CGFloat {
        return (getItemHeight(item: item) / 2) + (SchedulerView.Constant.spacing / 2)
    }
    
    func getPosition(item: SchedulerModel) -> CGFloat {
        let startingHour = getStartingHour(item: item)
        let zeroPosition = getZeroPosition(item: item)
        let finalPosition = zeroPosition + (SchedulerView.Constant.hourHeight * startingHour) + (startingHour * SchedulerView.Constant.spacing)
        
        return finalPosition
    }
    
    func getTimeInterval(item: SchedulerModel) -> CGFloat {
        let startTimeString = item.startDate
        let endTimeString = item.endDate
        
        guard let startTime = startTimeString.toDate()?.timeIntervalSince1970,
              let endTime = endTimeString.toDate()?.timeIntervalSince1970 else { return 0 }
        
        let difference = endTime - startTime
        let hour = difference / 3600
        
        return hour
    }
    
    func getStartingHour(item: SchedulerModel) -> CGFloat {
        let startTimeString = item.startDate
        guard let startTime = startTimeString.toDate(),
              let hour = Float(startTime.toString(format: "HH")),
              let minutes = Float(startTime.toString(format: "mm")) else { return 0 }
        
        let a = minutes / 60
        
        return CGFloat(hour + a)
    }
}

struct SchedulerModel: Hashable {
    let availabilityId: String
    let period: SchedulerPeriod
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

enum SchedulerPeriod: String, Decodable {
    case none
    case daily
    case weekly
    case monthly
}

struct SchedulerCapsuleView: View {
    var item: SchedulerModel
    
    var body: some View {
        VStack(spacing: 0) {
            if item.columnType == .inner || item.columnType == .tail {
                Text("⤵")
            }
            HStack {
                Text(getStartTime())
                    .font(.system(size: 11))
                    .padding(.horizontal, 4)
                Spacer()
            }
            Spacer()
            Text("\(item.capacity)")
            Spacer()
            HStack {
                Text(getEndTime())
                    .font(.system(size: 11))
                    .padding(.horizontal, 4)
                Spacer()
            }
            if item.columnType == .inner || item.columnType == .head {
                Text("⤴")
            }
        }
        
    }
    
    func getStartTime() -> String {
        item.startDate.showTimeFormat()
    }
    
    func getEndTime() -> String {
        item.endDate.showTimeFormat()
    }
}
