//
//  ViewModel.swift
//  WeekCalendar
//
//  Created by David Gomez on 24/06/2023.
//

import SwiftUI

class WeekSchedulerViewModel: BaseViewModel {
    @Published var availabilities: [Availability] = [] {
        didSet {
            generateItems()
        }
    }
    
    @Published var capsules: [SchedulerCapsuleModel] = []
    @Published var selectedCapsules: [SchedulerCapsuleModel] = []
    @Published var sheetType: SheetType = .new
    @Published var isShowingSheet = false
    @Published var isLoading = false

    var initialDate: Date
    var days: Int
    var startHour: Int
    var endHour: Int
    var hourWidth: CGFloat
    var boxWidth: CGFloat
    var boxHeight: CGFloat
    var calendarHeight: CGFloat
    var spacing: CGFloat
    var fixedBackgroundColor: Color = .gray.opacity(0.3)
    var dynamicBackgroundColor: Color = .gray.opacity(0.1)
    var selectionBackgroundColor: Color = .blue
    
    var item: ItemModelPresenter
    
    init(initialDate: Date, days: Int, startHour: Int, endHour: Int, hourWidht: CGFloat, boxWidth: CGFloat, boxHeight: CGFloat, calendarHeight: CGFloat, spacing: CGFloat, fixedBackgroundColor: Color, dynamicBackgroundColor: Color, selectionBackgroundColor: Color, item: ItemModelPresenter) {
        self.initialDate = initialDate.startOfDay()
        self.days = days
        self.startHour = startHour
        self.endHour = endHour
        self.hourWidth = hourWidht
        self.boxWidth = boxWidth
        self.boxHeight = boxHeight
        self.calendarHeight = calendarHeight
        self.spacing = spacing
        self.fixedBackgroundColor = fixedBackgroundColor
        self.dynamicBackgroundColor = dynamicBackgroundColor
        self.selectionBackgroundColor = selectionBackgroundColor
        self.item = item
    }
    
    @MainActor
    func loadAvailabilities() async {
        let usecase = AvailabilityUseCase()
        isLoading = true
        do {
            let input = AvailabilityEntity.Input(serviceId: item._id)
            let response = try await usecase.fetchAvailabilities(input: input)
            availabilities = response.availabilities
            isLoading = false
        } catch {
            handleError(error)
            isLoading = false
        }
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
    
    func selectAllCapsulesWithTheSameId(capsule: SchedulerCapsuleModel) {
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
    
    private func generateItems() {
        capsules.removeAll()
        for availability in availabilities {
            guard let startDate = availability.startDate.toDate(),
                  let endDate = availability.endDate.toDate() else { continue }
            
            switch availability.period {
            case .oneTime:
                capsules.append(contentsOf: addSingleItem(fromDate: startDate, toDate: endDate, availability: availability))
            case .daily:
                let dailyConstant = 1
                var result: [SchedulerCapsuleModel] = []
                for index in 0..<days / dailyConstant {
                    if let nextStartDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: startDate),
                       let nextEndDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: endDate) {
                        result.append(contentsOf: addSingleItem(fromDate: nextStartDate, toDate: nextEndDate, availability: availability))
                    }
                }
                capsules.append(contentsOf: result)
                break
            case .monthly:
                let monthlyConstant = 1
                let iteration = (days / 30) + 1
                var result: [SchedulerCapsuleModel] = []

                for index in 0..<iteration {
                    if let nextStartDate = Calendar.current.date(byAdding: .month, value: monthlyConstant * index, to: startDate),
                       let nextEndDate = Calendar.current.date(byAdding: .month, value: monthlyConstant * index, to: endDate) {
                        result.append(contentsOf: addSingleItem(fromDate: nextStartDate, toDate: nextEndDate, availability: availability))
                    }
                }
                capsules.append(contentsOf: result)
            case .weekly:
                let weeklyConstant = 7
                var result: [SchedulerCapsuleModel] = []
                for index in 0..<days / weeklyConstant {
                    if let nextStartDate = Calendar.current.date(byAdding: .day, value: weeklyConstant * index, to: startDate),
                       let nextEndDate = Calendar.current.date(byAdding: .day, value: weeklyConstant * index, to: endDate) {
                        result.append(contentsOf: addSingleItem(fromDate: nextStartDate, toDate: nextEndDate, availability: availability))
                    }
                }
                capsules.append(contentsOf: result)
            case .weekend:
                let dailyConstant = 1
                var result: [SchedulerCapsuleModel] = []
                for index in 0..<days / dailyConstant {
                    if let nextStartDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: startDate),
                       let nextEndDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: endDate) {
                        let weekDay = Calendar.current.component(.weekday, from: nextEndDate)
                        if weekDay == 7 || weekDay == 1 { // saturday and sunday
                            result.append(contentsOf: addSingleItem(fromDate: nextStartDate, toDate: nextEndDate, availability: availability))
                            
                        }
                    }
                }
                
                capsules.append(contentsOf: result)
                break
            case .business:
                let dailyConstant = 1
                var result: [SchedulerCapsuleModel] = []
                for index in 0..<days / dailyConstant {
                    if let nextStartDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: startDate),
                       let nextEndDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: endDate) {
                        let weekDay = Calendar.current.component(.weekday, from: nextEndDate)
                        if weekDay != 7 && weekDay != 1 { // business
                            result.append(contentsOf: addSingleItem(fromDate: nextStartDate, toDate: nextEndDate, availability: availability))
                        }
                    }
                }
                
                capsules.append(contentsOf: result)
                break
            case .workingDays:
                let dailyConstant = 1
                var result: [SchedulerCapsuleModel] = []
                for index in 0..<days / dailyConstant {
                    if let nextStartDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: startDate),
                       let nextEndDate = Calendar.current.date(byAdding: .day, value: dailyConstant * index, to: endDate) {
                        let weekDay = Calendar.current.component(.weekday, from: nextEndDate)
                        if weekDay != 1 { // working days (mon to sat)
                            result.append(contentsOf: addSingleItem(fromDate: nextStartDate, toDate: nextEndDate, availability: availability))
                        }
                    }
                }
                
                capsules.append(contentsOf: result)
                break
            }
        }
    }
    
    private func addSingleItem(fromDate: Date, toDate: Date, availability: Availability) -> [SchedulerCapsuleModel] {
        
        let components = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        guard let daysCounter = components.day else { return [] }
        let lastDateFromCalendar = Calendar.current.date(byAdding: .day, value: days, to: initialDate)!
        let expirationDate = availability.expiration?.toDate()

        var result: [SchedulerCapsuleModel] = []
        
        for index in 0..<(daysCounter + 1) {
            guard let startTimeDate = Calendar.current.date(byAdding: .day, value: index, to: fromDate) else { break }
           
            if startTimeDate > lastDateFromCalendar { // this is to avoid creating more capsules than the calendar screen width can support.
                return result
            }
            if let expirationDate = expirationDate, startTimeDate > expirationDate {
                return result
            }
           
            var startDate = startTimeDate.toString()
            var endDate = toDate.toString()
            
            var columnType: SchedulerCapsuleModel.ColumnType = .none
            
            // this is run only if startDate and endDate are different. But, generally we don't let users do that.
            if daysCounter > 0 {
                if index != 0 {
                    let startOfDay = startTimeDate.startOfDay()
                    startDate = startOfDay.toString()
                    
                    if index == daysCounter {
                        columnType = .tail
                        endDate = toDate.toString()
                    } else {
                        columnType = .inner
                        let endOfDay = startTimeDate.endOfDay()
                        endDate = endOfDay.toString()
                    }
                    
                } else {
                    columnType = .head
                    let endOfDay = startTimeDate.endOfDay()
                    endDate = endOfDay.toString()
                }
            }
            
            let newCapsule = SchedulerCapsuleModel(availabilityId: availability._id,
                                            period: availability.period,
                                            startDate: startDate,
                                            endDate: endDate,
                                            backgroundColor: Color.gray.opacity(0.15),
                                            columnType: columnType,
                                            expiration: availability.expiration)
            result.append(newCapsule)
        }
        
        return result
    }
    
    func createNewAvailability(date: Date) -> Availability {
        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        let endDate = Calendar.current.date(byAdding: .hour, value: 1, to: date)
        
        let newAvailability = Availability(_id: UUID().uuidString,
                                           period: .oneTime,
                                           startDate: date.toString(format: format),
                                           endDate: (endDate?.toString(format: format))!,
                                           service: "",
                                           isEnabled: true,
                                           createdAt: "",
                                           updatedAt: "",
                                           expiration: nil)
        
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
