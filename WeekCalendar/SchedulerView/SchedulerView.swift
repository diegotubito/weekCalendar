
//
//  CalendarView.swift
//  CustomView
//
//  Created by David Gomez on 17/06/2023.
//

import SwiftUI

struct SchedulerView: View {
    struct Constant {
        static let widthProportional: CGFloat = 0.90
        static let maxHours: CGFloat = 24
        static let spacing: CGFloat = 1
        static let hourHeight: CGFloat = 50
        static let hourWidth: CGFloat = 40
        static let cornerRadius: CGFloat = 5
        static let columnWidht: CGFloat = 70
        static let headerHeight: CGFloat = 50
    }
    
    var items: [SchedulerModel]
    var initialDate: Date
    let maxColumn: Int
    
    var body: some View {
        
        ScrollView(.vertical) {
            
            HStack(spacing: Constant.spacing) {
                VStack(spacing: Constant.spacing) {
                    Color(.clear)
                        .frame(width: SchedulerView.Constant.hourWidth, height: SchedulerView.Constant.hourHeight)
                    SchedulerHourView()
                }
                
                HStack(spacing: Constant.spacing) {
                    ScrollView(.horizontal) {
                        VStack(spacing: Constant.spacing) {
                            WeekCalendarView(initialDate: initialDate, selectedDate: Date(), maxDays: maxColumn, isSelectable: false, spacing: Constant.spacing) { selectedDate in
                                print(selectedDate)
                            } onVisibleDates: { visibleDates in
                                for i in visibleDates {
                                    print(i)
                                }
                            }
                            .frame(height: Constant.headerHeight)
                            
                            HStack(spacing: Constant.spacing) {
                                ForEach(0..<maxColumn, id: \.self) {index in
                                    SchedulerColumnView(items: filterAvailabilities(weekday: calculateWeekDay(index: index))) { model in
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
    
    func calculateWeekDay(index: Int) -> Int {
        let initialWeekDay = Calendar.current.component(.weekday, from: initialDate)
        return (index + initialWeekDay) % 7
    }
    
    func filterAvailabilities(weekday: Int) -> [SchedulerModel] {
        let filteredItems = items.filter({$0.dayOfWeek == weekday})
        return filteredItems
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerView(items: [], initialDate: Date(), maxColumn: 7)
    }
}



