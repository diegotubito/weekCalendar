//
//  WeekSchedulerHourView.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

struct WeekSchedulerHourView: View {
    var hours = Array(0..<Int(SchedulerView.Constant.maxHours))
    
    var hourWidth: CGFloat
    var hourHeight: CGFloat
    var spacing: CGFloat
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(hours, id: \.self) { hour in
                ZStack {
                    Color.clear.opacity(0.3)
                    
                    Text("\(hour):00")
                        .foregroundColor(Color.white.opacity(0.6))
                        .font(.caption)
                        .offset(x: 0, y: -(hourHeight / 2) - 1)
                    
                }
                .frame(width: hourWidth, height: hourHeight)
            }
        }
    }
    
    func getIndex(hour: Int) -> String {
        String(hours.lastIndex(of: hour)!)
    }
}

struct WeekSchedulerHourView_Previews: PreviewProvider {
    static var previews: some View {
        WeekSchedulerHourView(hourWidth: 50, hourHeight: 50, spacing: 1)
    }
}

