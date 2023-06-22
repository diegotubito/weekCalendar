//
//  WeekSchedulerBoxView.swift
//  WeekCalendar
//
//  Created by David Gomez on 21/06/2023.
//

import SwiftUI

struct WeekSchedulerBoxView: View {
    var body: some View {
        VStack {
            Text("Title")
                .font(.system(size: 12))
            Text("Subtitle")
                .font(.system(size: 10))
        }
    }
}

struct WeekSchedulerBoxView_Previews: PreviewProvider {
    static var previews: some View {
        WeekSchedulerBoxView()
    }
}
