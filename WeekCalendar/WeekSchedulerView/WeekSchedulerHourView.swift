//
//  WeekSchedulerHourView.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

struct WeekSchedulerHourView: View {
    var startHour: Int
    var endHour: Int
    var hourWidth: CGFloat
    var hourHeight: CGFloat
    var spacing: CGFloat
    
    private var hours: [Int]

    init(startHour: Int, endHour: Int, hourWidth: CGFloat, hourHeight: CGFloat, spacing: CGFloat) {
        self.startHour = startHour
        self.endHour = endHour
        self.hourWidth = hourWidth
        self.hourHeight = hourHeight
        self.spacing = spacing

        hours = Array(stride(from: startHour, through: endHour, by: 1))
    }

    var body: some View {
        VStack(spacing: spacing) {
            ForEach(hours, id: \.self) { hour in
                ZStack {
                    Color.clear.opacity(0.3)
                    
                    Text("\(hour):00")
                        .foregroundColor(Color.white.opacity(0.6))
                        .font(.caption)
                        .offset(x: 0, y: -(hourHeight / 2) + spacing * 2)
                    
                }
                .frame(width: hourWidth, height: hourHeight)
            }
        }
    }
}

struct WeekSchedulerHourView_Previews: PreviewProvider {
    static var previews: some View {
        WeekSchedulerHourView(startHour: 4, endHour: 10, hourWidth: 50, hourHeight: 50, spacing: 1)
    }
}

