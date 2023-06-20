
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
                            }
                            .frame(height: Constant.headerHeight)
                            
                            HStack(spacing: Constant.spacing) {
                                ForEach(0..<maxColumn, id: \.self) {index in
                                    SchedulerColumnView(items: filterItems(index: index)) { model in
                                        print(model.startDate)
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
    
    func calculateColumnDate(index: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: index, to: initialDate)!
    }
    
    func filterItems(index: Int) -> [SchedulerModel] {
        var result: [SchedulerModel] = []
        let columnDate = calculateColumnDate(index: index)
        
        // add non periodic items
        result.append(contentsOf: items.filter({ item in
            let isDaily = item.period == .daily
            
            let itemStartDate = item.startDate.toDate()!
            let correctDate = equalDates(date1: columnDate, date2: itemStartDate) != .orderedAscending
            
            return isDaily && correctDate
        }))
        
        // add non periodic items
        result.append(contentsOf: items.filter({$0.period == .none && areEqualDates(date1: columnDate, date2: $0.startDate.toDate()! ) }))
        
        // add weekly items
        result.append(contentsOf: items.filter({ item in
            let isWeekly = item.period == .weekly
            
            let itemStartDate = item.startDate.toDate()!
          
            let itemWeekDay = Calendar.current.component(.weekday, from: itemStartDate)
            let weekday = Calendar.current.component(.weekday, from: columnDate)
          
            let correctDate = equalDates(date1: columnDate, date2: itemStartDate) != .orderedAscending
            
            return isWeekly && (itemWeekDay == weekday) && (correctDate)
        }))
        
        // add monthly items
        result.append(contentsOf: items.filter({ item in
            let isMonthly = item.period == .monthly
            
            let itemStartDate = item.startDate.toDate()!
           
            let dayItem = Calendar.current.component(.day, from: itemStartDate)
            let dayColumn = Calendar.current.component(.day, from: columnDate)
            let isDayEqual = dayItem == dayColumn

            let correctDate = equalDates(date1: columnDate, date2: itemStartDate) != .orderedAscending
            
            return isMonthly && isDayEqual && correctDate
        }))
        
        
        return result
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerView(items: [], initialDate: Date(), maxColumn: 7)
    }
}



