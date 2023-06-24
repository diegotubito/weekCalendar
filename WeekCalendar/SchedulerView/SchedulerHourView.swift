//
//  HourView.swift
//  CustomView
//
//  Created by David Gomez on 18/06/2023.
//

import SwiftUI

struct SchedulerHourView: View {
    var hours = Array(0..<Int(SchedulerView.Constant.maxHours + 1))
    
    var body: some View {
        VStack(spacing: SchedulerView.Constant.spacing) {
            ForEach(hours, id: \.self) { hour in
                ZStack {
                    Color.clear.opacity(0.3)
                    if hour == 0 {
                        Text("")
                            .foregroundColor(Color.white.opacity(0.6))
                            .font(.caption)
                            .offset(x: 0, y: -(SchedulerView.Constant.hourHeight / 2) - 1)

                    } else {
                        Text("\(hour - 1):00")
                            .foregroundColor(Color.white.opacity(0.6))
                            .font(.caption)
                            .offset(x: 0, y: -(SchedulerView.Constant.hourHeight / 2) - 1)
                    }
                }
                .frame(width: SchedulerView.Constant.hourWidth, height: SchedulerView.Constant.hourHeight)
            }
        }
    }
    
    func getIndex(hour: Int) -> String {
        String(hours.lastIndex(of: hour)!)
    }
}


struct HourView_Previews: PreviewProvider {
    static var previews: some View {
        SchedulerHourView()
    }
}
