//
//  ContentView.swift
//  WeekCalendar
//
//  Created by David Gomez on 18/06/2023.
//

import SwiftUI

struct ContentView: View {
    var currentDate = Date()
    @State var assignments: [Assignment] = []
    @State var availabilities: [Availability] = []
    @State var capsules: [SchedulerModel] = []
    
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
        VStack {
            SchedulerView(items: capsules,
                          initialDate: currentDate,
                          maxColumn: 90, didTapped: { model in
                print(model.id)
                print(model.date)
                createNewAvailability(model: model)
            })
            .background(Color.black)
        }
        .onAppear {
            availabilities = loadAvailabilities()
            assignments = loadAssignment(toAvailability: availabilities.first!)
            capsules = generateItems(availabilities: availabilities)
        }
    }
    
    func createNewAvailability(model: SchedulerView.TappedModel) {
        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: model.date)
        
        let newAvailability = Availability(_id: "003",
                                           period: .weekly,
                                           capacity: 21,
                                           startDate: model.date.toString(format: format),
                                           endDate: (endDate?.toString(format: format))!,
                                           service: "",
                                           isEnabled: true,
                                           priceAdjustmentPercentage: 10,
                                           createdAt: "",
                                           updatedAt: "")
        if let newCapsule = addSingleItem(availability: newAvailability) {
            capsules.append(newCapsule)
        }
        
    }
    
    func getNearSunday(date: Date) -> Date {
        let weekDay = Calendar.current.component(.weekday, from: date)
       
        guard let fromDate = Calendar.current.date(byAdding: .day, value: -(weekDay - 1), to: date) else { return Date() }
        return fromDate
      
    }
    
    func loadAssignment(toAvailability: Availability) -> [Assignment] {
        let assignment1 = Assignment(_id: "0000001",
                                    availability: toAvailability,
                                    status: "user-pending",
                                    startDate: "2023-06-17T00:00:00.000Z",
                                    amount: 1500,
                                    createdAt: "",
                                    updatedAt: "",
                                    expiration: nil)
        
        return [assignment1]
    }
    
    func loadAvailabilities() -> [Availability] {
    
        let availability1 = Availability(_id: "1110",
                                        period: .monthly,
                                        capacity: 33,
                                        startDate: "2023-06-12T04:00:00.000Z",
                                        endDate: "2023-06-12T013:30:00.000Z",
                                        service: "",
                                        isEnabled: true,
                                        priceAdjustmentPercentage: 10,
                                        createdAt: "",
                                        updatedAt: "")
        
       
        return [availability1]
    }
    
    func addSingleItem(availability: Availability) -> SchedulerModel? {
        guard let availabilityStartDate = availability.startDate.toDate(),
              let endDate = availability.endDate.toDate() else { return nil }
        
        let components = Calendar.current.dateComponents([.day], from: availabilityStartDate, to: endDate)
        guard let days = components.day else { return nil }

        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        var result: SchedulerModel?

        for index in 0..<(days + 1) {
            guard let startTimeDate = Calendar.current.date(byAdding: .day, value: index, to: availabilityStartDate) else { break }
            
            var columnType: SchedulerModel.ColumnType = .none
            var startDate = startTimeDate.toString(format: format)
            var endDate = availability.endDate

            if days > 0 {
                if index != 0 {
                    let startOfDay = startTimeDate.startOfDay()
                    startDate = startOfDay.toString(format: format)
                    
                    if index == days {
                        columnType = .tail
                        endDate = availability.endDate
                    } else {
                        columnType = .inner
                        let endOfDay = startTimeDate.endOfDay()
                        endDate = endOfDay.toString(format: format)
                    }
                    
                } else {
                    columnType = .head
                    let endOfDay = startTimeDate.endOfDay()
                    endDate = endOfDay.toString(format: format)
                }
            }
            
            let newCapsule = SchedulerModel(availabilityId: availability._id,
                                            period: availability.period,
                                            capacity: availability.capacity,
                                            startDate: startDate,
                                            endDate: endDate,
                                            backgroundColor: Color.green,
                                            columnType: columnType)
            result = newCapsule
        }

        return result
    }
    
    func generateItems(availabilities: [Availability]) -> [SchedulerModel]{
        var result: [SchedulerModel] = []

        for availability in availabilities {
            if let newItem = addSingleItem(availability: availability) {
                result.append(newItem)
            }
        }
        
        return result
    }
    
    func numberOfDaysBetweenDates(date1: Date, date2: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Availability: Decodable, Hashable {
    let _id: String
    let period: SchedulerPeriod
    let capacity: Int
    let startDate: String
    let endDate: String
    let service: String
    let isEnabled: Bool
    let priceAdjustmentPercentage: Int
    let createdAt: String
    let updatedAt: String
}



struct Assignment: Decodable, Hashable {
    let _id: String
    let availability: Availability
    let status: String
    let startDate: String
    let amount: Double
    let createdAt: String
    let updatedAt: String
    let expiration: Expiration?
    
    struct Expiration: Decodable, Hashable {
        let _id: String
        let duration: Int
        let startDate: String?
    }
}

enum AssignmentStatus: String {
    case userPending
    case ownerAccepted
    case ownerRejected
    case userScheduled
    case userCancelled
}
