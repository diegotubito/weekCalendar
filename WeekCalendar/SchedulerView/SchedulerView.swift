
//
//  CalendarView.swift
//  CustomView
//
//  Created by David Gomez on 17/06/2023.
//

import SwiftUI

struct SchedulerView: View {
    struct Constant {
        static let widthProportional: CGFloat = 0.95
        static let maxHours: CGFloat = 24
        static let spacing: CGFloat = 1
        static let hourHeight: CGFloat = 50
        static let hourWidth: CGFloat = 40
        static let cornerRadius: CGFloat = 5
        static let maxColumns = 7
        static let columnWidht: CGFloat = 70
        static let headerHeight: CGFloat = 50
    }
    
    var body: some View {
        
        ScrollView(.vertical) {
            
            HStack(spacing: Constant.spacing) {
                VStack(spacing: Constant.spacing) {
                    Spacer(minLength: Constant.hourHeight)
                    SchedulerHourView()
                }
                
                HStack(spacing: Constant.spacing) {
                    ScrollView(.horizontal) {
                        VStack(spacing: Constant.spacing) {
                            WeekCalendarView(initialDate: Date(), selectedDate: Date(), maxDays: Constant.maxColumns, isSelectable: false, spacing: Constant.spacing) { selectedDate in
                                print(selectedDate)
                            } onVisibleDates: { visibleDates in
                                for i in visibleDates {
                                    print(i)
                                }
                            }
                            .frame(height: Constant.headerHeight)
                            
                            HStack(spacing: Constant.spacing) {
                                ForEach(0..<Constant.maxColumns) {index in
                                    SchedulerColumnView(items: loadAvailability()) { model in
                                        print(model.startTime)
                                    } emptyHourDidTapped: { hourIndex in
                                        print(hourIndex, index)
                                    }
                                    .frame(width: Constant.columnWidht)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerView()
    }
}

func loadAvailability() -> [SchedulerModel] {
    let item1 = SchedulerModel(dayOfWeek: 1, startTime: "2000-01-01T03:00:00.000Z", endTime: "2000-01-01T04:30:00.000Z", backgroundColor: Color.blue.opacity(0.7))
    let item2 = SchedulerModel(dayOfWeek: 1, startTime: "2000-01-01T09:00:00.000Z", endTime: "2000-01-01T10:00:00.000Z", backgroundColor: Color.blue.opacity(0.7))
    let item3 = SchedulerModel(dayOfWeek: 1, startTime: "2000-01-01T16:00:00.000Z", endTime: "2000-01-01T19:00:00.000Z", backgroundColor: Color.blue.opacity(0.7))
    let item4 = SchedulerModel(dayOfWeek: 1, startTime: "2000-01-01T20:00:00.000Z", endTime: "2000-01-02T03:00:00.000Z", backgroundColor: Color.blue.opacity(0.7))
    
    let item5 = SchedulerModel(dayOfWeek: 1, startTime: "2000-01-01T12:00:00.000Z", endTime: "2000-01-01T13:00:00.000Z", backgroundColor: Color.pink.opacity(0.3))
    
    return [item1, item2, item3, item4, item5]
}

