//
//  WeekView.swift
//  WeekCalendar
//
//  Created by David Gomez on 18/06/2023.
//

import SwiftUI

struct WeekView: View {
    @State var initialDate: Date
    @State var selectedDate: Date
    @State var visibleDates: [Model] = []
    @State var maxDays: Int
    var isSelectable: Bool
    
    init(initialDate: Date, selectedDate: Date = Date(), maxDays: Int, isSelectable: Bool, onSelectedDate: ((Date) -> Void)?, onVisibleDates: (([Date]) -> Void)?) {
        self._initialDate = State(initialValue: initialDate)
        self._selectedDate = State(initialValue: selectedDate)
        self.onSelectedDate = onSelectedDate
        self.onVisibleDates = onVisibleDates
        self.isSelectable = isSelectable
        self._maxDays = State(initialValue: maxDays)
    }
        
    struct Model: Hashable {
        let date: Date
    }
    
    var onSelectedDate: ((Date) -> Void)?
    var onVisibleDates: (([Date]) -> Void)?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 8) {
                HStack(spacing: 1) {
                    ForEach(visibleDates, id: \.self) { date in
                        VStack(spacing: 1) {
                            Text("\(getDayName(date: date.date))")
                                .font(.caption)
                            Text("\(getDay(date: date.date))")
                                .font(.system(size: 13))
                                .foregroundColor(equalDates(date1: Date(), date2: date.date) == .orderedSame ? Color.red : Color.black.opacity(0.7))
                                .padding(8)
                                .background(getDayBackgroundColor(date: date.date))
                                .cornerRadius(15)
                                .onTapGesture {
                                    if isSelectable {
                                        selectedDate = date.date
                                        onSelectedDate?(selectedDate)
                                    }
                                }
                        }
                        .frame(width: geometry.size.width / CGFloat(maxDays))
                        .background(.gray.opacity(0.3))
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
    
    func equalDates(date1: Date, date2: Date) -> ComparisonResult {
        let calendar = Calendar.current
        let comparisonResult = calendar.compare(date1, to: date2, toGranularity: .day)

        return comparisonResult
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
        WeekView(initialDate: Date(), selectedDate: Date(), maxDays: 3, isSelectable: true, onSelectedDate: { selectedDate in
            
        }, onVisibleDates: { dates in
            
        })
    }
}
