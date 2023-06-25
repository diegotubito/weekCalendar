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
    
    @Published var capsules: [SchedulerCapsuleModel] = [] {
        didSet {
            print(capsules.count)
        }
    }
    @Published var selectedCapsules: [SchedulerCapsuleModel] = []
    @Published var openSheet: SheetType = .none
    @Published var isShowingSheet = false

    var initialDate: Date
    var days: Int
    var startHour: Int
    var endHour: Int
    var boxWidth: CGFloat
    var boxHeight: CGFloat
    var calendarHeight: CGFloat
    var spacing: CGFloat
    
    init(initialDate: Date, days: Int, startHour: Int, endHour: Int, boxWidth: CGFloat, boxHeight: CGFloat, calendarHeight: CGFloat, spacing: CGFloat) {
        self.initialDate = initialDate.startOfDay()
        self.days = days
        self.startHour = startHour
        self.endHour = endHour
        self.boxWidth = boxWidth
        self.boxHeight = boxHeight
        self.calendarHeight = calendarHeight
        self.spacing = spacing
    }
    
    func getPositionX(item: SchedulerCapsuleModel) -> CGFloat {
        let diff = getDayDifference(date1: initialDate, date2: item.startDate.toDate()!)
        let index: CGFloat = CGFloat(diff)
        let zeroPosition = boxWidth / 2
        let spacingOffset = spacing * index
        let result = zeroPosition + (boxWidth * index) + spacingOffset
        return result
    }
    
    private func getDayDifference(date1: Date, date2: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: date1, to: date2)
        guard let days = components.day else { return 0 }
        
        return days
    }
    
    private func numberOfDaysBetweenDates(date1: Date, date2: Date) -> Int? {
        let components = Calendar.current.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
    
    func getPositionY(item: SchedulerCapsuleModel) -> CGFloat {
        var startingHour = getStartingHour(item: item) - CGFloat(startHour)
        if startingHour < 0 {
            startingHour = 0
        }
        
        return getZeroPosition(item: item) + (boxHeight * startingHour) + (startingHour * spacing)
        
    }
    
    private func getStartingHour(item: SchedulerCapsuleModel) -> CGFloat {
        let startTimeString = item.startDate
        guard let startTime = startTimeString.toDate(),
              let hour = Float(startTime.toString(format: "HH")),
              let minutes = Float(startTime.toString(format: "mm")) else { return 0 }
        
        let a = minutes / 60
        
        return CGFloat(hour + a)
    }
    
    private func getZeroPosition(item: SchedulerCapsuleModel) -> CGFloat {
        return (getItemHeight(item: item) / 2) + (spacing / 2)
    }
    
    func selectAllSameId(capsule: SchedulerCapsuleModel) {
        selectedCapsules = capsules.filter({$0.availabilityId == capsule.availabilityId})
    }
    
    func getItemHeight(item: SchedulerCapsuleModel) -> CGFloat {
        let timeInterval = getTimeInterval(item: item)
        let height = timeInterval * (boxHeight) + (timeInterval * spacing) - (spacing * 2)
        var diff: CGFloat = 0
        if item.columnType == .tail {
            diff = (CGFloat(startHour) * boxHeight) + (CGFloat(startHour) * spacing)
        }
        return height - diff
    }
    
    private func getTimeInterval(item: SchedulerCapsuleModel) -> CGFloat {
        let startTimeString = item.startDate
        let endTimeString = item.endDate
        
        guard let startTime = startTimeString.toDate()?.timeIntervalSince1970,
              let endTime = endTimeString.toDate()?.timeIntervalSince1970 else { return 0 }
        
        let difference = endTime - startTime
        let hour = difference / 3600
        
        return hour
    }
    
    func loadAvailabilities() {
        availabilities.removeAll()
        let availability1 = Availability(_id: "1110",
                                         period: .daily,
                                         capacity: 33,
                                         startDate: "2023-06-14T19:00:00.000Z",
                                         endDate: "2023-06-14T20:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        let availability2 = Availability(_id: "1100",
                                         period: .none,
                                         capacity: 33,
                                         startDate: "2023-06-13T15:00:00.000Z",
                                         endDate: "2023-06-13T17:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        let availability3 = Availability(_id: "1000",
                                         period: .none,
                                         capacity: 33,
                                         startDate: "2023-06-13T15:00:00.000Z",
                                         endDate: "2023-06-13T18:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        let availability4 = Availability(_id: "11000",
                                         period: .none,
                                         capacity: 33,
                                         startDate: "2023-06-15T15:00:00.000Z",
                                         endDate: "2023-06-17T18:00:00.000Z",
                                         service: "",
                                         isEnabled: true,
                                         priceAdjustmentPercentage: 10,
                                         createdAt: "",
                                         updatedAt: "")
        
        
        availabilities = [availability1, availability2, availability3, availability4]
    }
    
    private func generateItems() {
        capsules.removeAll()
        for availability in availabilities {
            switch availability.period {
            case .none:
                capsules.append(contentsOf: addSingleItem(fromDate: availability.startDate.toDate()!, toDate: availability.endDate.toDate()!, availability: availability))
            case .daily:
                let dailyConstant = 1
                var result: [SchedulerCapsuleModel] = []
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
                let monthlyConstant = 1
                let iteration = (days / 30) + 1
                var result: [SchedulerCapsuleModel] = []

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
                var result: [SchedulerCapsuleModel] = []
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
    
    private func addSingleItem(fromDate: Date, toDate: Date, availability: Availability) -> [SchedulerCapsuleModel] {
        
        let components = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        guard let daysCounter = components.day else { return [] }
        let lastDate = Calendar.current.date(byAdding: .day, value: days, to: initialDate)!

        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        var result: [SchedulerCapsuleModel] = []
        
        for index in 0..<(daysCounter + 1) {
            guard let startTimeDate = Calendar.current.date(byAdding: .day, value: index, to: fromDate) else { break }
           
            if startTimeDate > lastDate { // this is to avoid creating more capsules than the calendar screen width can support.
                return result
            }
           
            var startDate = startTimeDate.toString(format: format)
            var endDate = toDate.toString(format: format)
            
            var columnType: SchedulerCapsuleModel.ColumnType = .none
            
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
            
            let newCapsule = SchedulerCapsuleModel(availabilityId: availability._id,
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
        
        availabilities.append(newAvailability)
        return newAvailability
    }
    
    func getTotalWidth() -> CGFloat {
        return CGFloat(days) * boxWidth + (CGFloat(days) * spacing)
    }
    
    func getTotalHeight() -> CGFloat {
        return CGFloat(endHour - startHour) * boxHeight + (CGFloat(endHour - startHour) * spacing) + calendarHeight + spacing
    }
}
