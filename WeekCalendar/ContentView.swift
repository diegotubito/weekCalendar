//
//  ContentView.swift
//  WeekCalendar
//
//  Created by David Gomez on 18/06/2023.
//

import SwiftUI

struct ContentView: View {
    var currentDate = Date()
    
    init(currentDate: Date = Date()) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = 2023
        dateComponents.month = 6
        dateComponents.day = 28

        if let particularDate = calendar.date(from: dateComponents) {
            self.currentDate = particularDate
        }
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            WeekView(initialDate: getNearSunday(date: Date()), selectedDate: currentDate, maxDays: 3, isSelectable: false) { selectedDate in
                print(selectedDate)
            } onVisibleDates: { visibleDates in
                for i in visibleDates {
                    print(i)
                }
            }

        }
        .padding()
    }
    
    func getNearSunday(date: Date) -> Date {
        let weekDay = Calendar.current.component(.weekday, from: date)
       
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -(weekDay - 1), to: date) else { return Date() }
        return fromDate
      
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
