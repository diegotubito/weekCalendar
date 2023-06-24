//
//  ViewModel.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

class WeekSchedulerViewModel: ObservableObject {
    @Published var availabilities: [Availability] = [] {
        didSet {
            generateItems()
        }
    }
    
    @Published var capsules: [SchedulerModel] = []
    @Published var selectedCapsules: [SchedulerModel] = []
    
    var initialDate: Date
    var days: Int
    var startHour: Int
    var endHour: Int

    
    init(initialDate: Date, days: Int, startHour: Int, endHour: Int) {
        self.initialDate = initialDate
        self.days = days
        self.startHour = startHour
        self.endHour = endHour
    }
    
    func selectAllSameId(capsule: SchedulerModel) {
        selectedCapsules = capsules.filter({$0.availabilityId == capsule.availabilityId})
    }
    
    func loadAvailabilities() {
        availabilities.removeAll()
        let availability1 = Availability(_id: "1110",
                                         period: .none,
                                         capacity: 33,
                                         startDate: "2023-06-13T15:00:00.000Z",
                                         endDate: "2023-06-13T16:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        let availability2 = Availability(_id: "1110",
                                         period: .none,
                                         capacity: 33,
                                         startDate: "2023-06-13T15:00:00.000Z",
                                         endDate: "2023-06-13T17:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        let availability3 = Availability(_id: "1110",
                                         period: .none,
                                         capacity: 33,
                                         startDate: "2023-06-13T15:00:00.000Z",
                                         endDate: "2023-06-13T18:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        
        availabilities = [availability1, availability2, availability3]
        
        generateItems()
    }
    
    private func generateItems() {
        capsules.removeAll()
        for availability in availabilities {
            switch availability.period {
            case .none:
                capsules.append(contentsOf: addSingleItem(fromDate: availability.startDate.toDate()!, toDate: availability.endDate.toDate()!, availability: availability))
            case .daily:
                let dailyConstant = 1
                var result: [SchedulerModel] = []
                for index in 0..<days / dailyConstant {
                    let fromDate = availability.startDate.toDate()!
                    let correctFromDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: fromDate)
                    let toDate = availability.endDate.toDate()!
                    let correctToDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: toDate)
                    result.append(contentsOf: addSingleItem(fromDate: correctFromDate!, toDate: correctToDate!, availability: availability))
                }
                
                capsules.append(contentsOf: result)
                break
            case .monthly:
                let monthlyConstant = 1 // month
                let iteration = (days / 30) + 1
                var result: [SchedulerModel] = []

                for index in 0..<iteration {
                    let fromDate = availability.startDate.toDate()!
                    let correctFromDate = Calendar.current.date(byAdding: .month, value: monthlyConstant * index, to: fromDate)
                    let toDate = availability.endDate.toDate()!
                    let correctToDate = Calendar.current.date(byAdding: .month, value: monthlyConstant * index, to: toDate)
                    result.append(contentsOf: addSingleItem(fromDate: correctFromDate!, toDate: correctToDate!, availability: availability))
                }
                capsules.append(contentsOf: result)
            case .weekly:
                let weeklyConstant = 7
                var result: [SchedulerModel] = []
                for index in 0..<days / weeklyConstant {
                    let fromDate = availability.startDate.toDate()!
                    let correctFromDate = Calendar.current.date(byAdding: .day, value: weeklyConstant * index, to: fromDate)
                    let toDate = availability.endDate.toDate()!
                    let correctToDate = Calendar.current.date(byAdding: .day, value: weeklyConstant * index, to: toDate)
                    result.append(contentsOf: addSingleItem(fromDate: correctFromDate!, toDate: correctToDate!, availability: availability))
                }
                capsules.append(contentsOf: result)
            }
        }
    }
    
    func addSingleItem(fromDate: Date, toDate: Date, availability: Availability) -> [SchedulerModel] {
        
        let components = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        guard let daysCounter = components.day else { return [] }
        let lastDate = Calendar.current.date(byAdding: .day, value: days, to: initialDate)!

        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        var result: [SchedulerModel] = []
        
        for index in 0..<(daysCounter + 1) {
            guard let startTimeDate = Calendar.current.date(byAdding: .day, value: index, to: fromDate) else { break }
           
            if startTimeDate >= lastDate { // this is to avoid creating more capsules than the calendar screen width can support.
                return []
            }
           
            var startDate = startTimeDate.toString(format: format)
            var endDate = toDate.toString(format: format)
            
            var columnType: SchedulerModel.ColumnType = .none
            
            if daysCounter > 0 {
                if index != 0 {
                    let startOfDay = startTimeDate.startOfDay()
                    startDate = startOfDay.toString(format: format)
                    
                    if index == daysCounter {
                        columnType = .tail
                        endDate = toDate.toString(format: format)
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
                                            backgroundColor: Color.gray.opacity(0.15),
                                            columnType: columnType)
            result.append(newCapsule)
        }
        
        return result
    }
    
    func createNewAvailability(date: Date) -> Availability {
        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: date)
        
        let newAvailability = Availability(_id: UUID().uuidString,
                                           period: .none,
                                           capacity: 21,
                                           startDate: date.toString(format: format),
                                           endDate: (endDate?.toString(format: format))!,
                                           service: "",
                                           isEnabled: true,
                                           priceAdjustmentPercentage: 10,
                                           createdAt: "",
                                           updatedAt: "")
        
        return newAvailability
    }
    
}
