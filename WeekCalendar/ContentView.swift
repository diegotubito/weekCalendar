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
        dateComponents.day = 12

        if let particularDate = calendar.date(from: dateComponents) {
            self.currentDate = particularDate
        }
    }
    
    var body: some View {
        CustomNavigationStack(viewmodel: BaseViewModel()) {
            VStack {
                WeekSchedulerView(viewmodel: WeekSchedulerViewModel(initialDate: getNearSunday(date: Date()),
                                                                    days: 30,
                                                                    startHour: 0,
                                                                    endHour: 23,
                                                                    hourWidht: 50,
                                                                    boxWidth: 50,
                                                                    boxHeight: 50,
                                                                    calendarHeight: 50,
                                                                    spacing: 1,
                                                                    fixedBackgroundColor: Color.Dark.tone90.opacity(0.3),
                                                                    dynamicBackgroundColor: Color.Dark.tone90.opacity(0.25),
                                                                    selectionBackgroundColor: Color.Blue.tone300,
                                                                    item: mockFakeItem()))
            }
            .background(Color.black)
        }
        .onAppear {
            let loginViewModel = LoginViewModel()
            Task {
                await loginViewModel.doLogin()
            }
        }
    }
    
    func getNearSunday(date: Date) -> Date {
        let weekDay = Calendar.current.component(.weekday, from: date)
       
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -(weekDay - 1), to: date) else { return Date() }
        return fromDate
      
    }
    
    func mockFakeItem() -> ItemModelPresenter {
        return ItemModelPresenter(_id: "6441da2f9c142110feef13e6",
                                  title: "Cancha de 9",
                                  subtitle: "",
                                  itemType: "service",
                                  price: 33,
                                  isEnabled: true,
                                  spot: "6441d9d09c142110feef13d1",
                                  createdAt: "",
                                  updatedAt: "",
                                  images: [],
                                  image: UIImage(systemName: "pencil")!,
                                  imageState: .loaded,
                                  availabilities: [],
                                  availabilitiesState: .loaded)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
