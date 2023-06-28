//
//  WeekView.swift
//  WeekCalendar
//
//  Created by David Gomez on 18/06/2023.
//

import SwiftUI

struct WeekCalendarView: View {
    @State var initialDate: Date
    @State var selectedDate: Date
    @State var visibleDates: [Model] = []
    @State var maxDays: Int
    var isSelectable: Bool
    var spacing: CGFloat
    var fixedBackgroundColor: Color
    
    init(initialDate: Date, selectedDate: Date = Date(), maxDays: Int, isSelectable: Bool, spacing: CGFloat, columnWidth: CGFloat, height: CGFloat, fixedBackgroundColor: Color, onSelectedDate: ((Date) -> Void)?, onVisibleDates: (([Date]) -> Void)?) {
        self._initialDate = State(initialValue: initialDate)
        self._selectedDate = State(initialValue: selectedDate)
        self.onSelectedDate = onSelectedDate
        self.onVisibleDates = onVisibleDates
        self.isSelectable = isSelectable
        self._maxDays = State(initialValue: maxDays)
        self.spacing = spacing
        self.columnWidht = columnWidth
        self.height = height
        self.fixedBackgroundColor = fixedBackgroundColor
    }
    
    struct Model: Hashable {
        let date: Date
    }
    
    var onSelectedDate: ((Date) -> Void)?
    var onVisibleDates: (([Date]) -> Void)?
    
    var columnWidht: CGFloat
    var height: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: spacing) {
                ForEach(visibleDates, id: \.self) { item in
                    VStack(spacing: spacing) {
                        Text("\(getDayName(date: item.date))")
                            .font(.caption)
                            .foregroundColor(getDayForegroundColor(date: item.date))
                        Text("\(getDay(date: item.date))")
                            .font(.system(size: 13))
                            .foregroundColor(getDayForegroundColor(date: item.date))
                            .padding(8)
                            .background(getDayBackgroundColor(date: item.date))
                            .cornerRadius(15)
                            .onTapGesture {
                                if isSelectable {
                                    selectedDate = item.date
                                    onSelectedDate?(selectedDate)
                                }
                            }
                    }
                    .frame(width: columnWidht, height: height)
                    .background(fixedBackgroundColor)
                }
            }
            if isSelectable {
                Text(getFullDateName(date: selectedDate))
            }
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onEnded { value in
                    let gestureThreshold: CGFloat = 100.0
                    if value.translation.width < -gestureThreshold {
                        // Swiped left
                        getNextWeek()
                    } else if value.translation.width > gestureThreshold {
                        // Swiped right
                        getPreviousWeek()
                    }
                }
        )
        .onAppear {
            getWeekItems(containigDate: initialDate)
        }
    }
    
    func getDayForegroundColor(date: Date) -> Color {
        equalDates(date1: Date(), date2: date) == .orderedSame ? Color.red : Color.white.opacity(0.7)
    }
    
    func getDayBackgroundColor(date: Date) -> Color {
        (equalDates(date1: date, date2: selectedDate) == .orderedSame && isSelectable) ? .blue : .clear
    }
    
    func getNextWeek() {
        if let nextWeek = Calendar.current.date(byAdding: .day, value: maxDays, to: initialDate) {
            initialDate = nextWeek
            getWeekItems(containigDate: nextWeek)
        }
    }
    
    func getPreviousWeek() {
        if let nextWeek = Calendar.current.date(byAdding: .day, value: -maxDays, to: initialDate) {
            initialDate = nextWeek
            getWeekItems(containigDate: nextWeek)
        }
    }
    
    func getFullDateName(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        let currentDate = date
        let fullDate = dateFormatter.string(from: currentDate)
        return fullDate
    }
    
    func getDayName(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let currentDate = date
        let dayName = dateFormatter.string(from: currentDate)
        return String(String(dayName).capitalized.prefix(3))
    }
    
    func getWeekDay(date: Date) -> Int {
        Calendar.current.component(.weekday, from: date)
    }
    
    func getDay(date: Date) -> Int {
        Calendar.current.component(.day, from: date)
    }
    
    func getWeekItems(containigDate: Date) {
        var result: [Model] = []
        for index in 0..<maxDays {
            
            if let nextDate = Calendar.current.date(byAdding: .day, value: index, to: initialDate) {
                
                let item = Model(date: nextDate)
                
                result.append(item)
            }
        }
        
        visibleDates = result
        let dates = visibleDates.map({$0.date})
        onVisibleDates?(dates)
    }
}

struct WeekView_Previews: PreviewProvider {
    static var previews: some View {
        WeekCalendarView(initialDate: Date(), selectedDate: Date(), maxDays: 3, isSelectable: true, spacing: 1, columnWidth: 58, height: 58, fixedBackgroundColor: .gray.opacity(0.25), onSelectedDate: { selectedDate in
            
        }, onVisibleDates: { dates in
            
        })
    }
}

func equalDates(date1: Date, date2: Date) -> ComparisonResult {
    let calendar = Calendar.current
    let comparisonResult = calendar.compare(date1, to: date2, toGranularity: .day)
    
    return comparisonResult
}

func areEqualDates(date1: Date, date2: Date) -> Bool {
    let calendar = Calendar.current
    let comparisonResult = calendar.compare(date1, to: date2, toGranularity: .day)
    if comparisonResult == .orderedSame { return true }
    return false
}
