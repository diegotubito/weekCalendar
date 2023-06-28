//
//  WeekSchedulerSheetViewModel.swift
//  WeekCalendar
//
//  Created by David Gomez on 26/06/2023.
//

import SwiftUI

class AvailabilitySheetViewModel: BaseViewModel {
    var item: ItemModelPresenter
    var type: SheetType
    var capsule: SchedulerCapsuleModel
        
    @Published var selectedStartDate: Date {
        didSet {
            selectedEndDate = Calendar.current.date(byAdding: .hour, value: 1, to: selectedStartDate)!
        }
    }
    @Published var selectedEndDate: Date
    
    @Published var selectedPeriod: SchedulerCapsulePeriod {
        didSet {
            if selectedPeriod == .oneTime {
                doesExpyre = false
            }
            if selectedPeriod == .weekly {
                let weekName = selectedStartDate.getDayName().capitalized.prefix(3)
                selectedClones = [String(weekName)]
            }
        }
    }
    
    @Published var availability: Availability?
    @Published var doesExpyre: Bool
    @Published var selectedExpirationDate: Date
    
    @Published var selectedClones: [String] = []

    
    init(item: ItemModelPresenter, type: SheetType, capsule: SchedulerCapsuleModel) {
        self.item = item
        self.type = type
        self.capsule = capsule
        
        selectedStartDate = capsule.startDate.toDate()!
        selectedEndDate = capsule.endDate.toDate()!
        selectedPeriod = capsule.period
        doesExpyre = capsule.expiration == nil ? false : true
        selectedExpirationDate = capsule.expiration?.toDate() ?? capsule.endDate.toDate()!
    }

    enum WeekDay: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
    }
    
    private func getNext(weekday: Int, fromDate: Date) -> Date {
        let currentWeekDay = Calendar.current.component(.weekday, from: fromDate)

        var sum = 0
        
        if currentWeekDay > weekday {
            sum = 7 - (currentWeekDay - weekday)
        } else if currentWeekDay < weekday {
            sum = (weekday - currentWeekDay)
        } else {
            sum = 0
        }
        
        return Calendar.current.date(byAdding: .day, value: sum, to: fromDate) ?? Date()
    }
    
    func saveAvailability() {
        let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        
        if selectedPeriod == .weekly {
            let expiration = doesExpyre ? selectedExpirationDate.endOfDay().toString(format: format) : nil
            let weeknames = getWeekNames()
            
            for dayName in selectedClones {
                let index = (weeknames.lastIndex(where: { $0.prefix(3) == dayName.prefix(3)} ) ?? 0) + 1
                
                let nextStartDate = getNext(weekday: index, fromDate: selectedStartDate).toString(format: format)
                let nextEndDate = getNext(weekday: index, fromDate: selectedEndDate).toString(format: format)
                
                Task {
                    await saveAvailability(startDate: nextStartDate, endDate: nextEndDate, expiration: expiration)
                }
            }
        } else {
            let startDate = selectedStartDate.toString(format: format)
            let endDate = selectedEndDate.toString(format: format)
            let expiration = doesExpyre ? selectedExpirationDate.endOfDay().toString(format: format) : nil
            
            Task {
                await saveAvailability(startDate: startDate, endDate: endDate, expiration: expiration)
            }
        }
    }
    
    @MainActor
    private func saveAvailability(startDate: String, endDate: String, expiration: String?) async {
        let usecase = AvailabilityUseCase()
        do {
            let input = AvailabilityEntity.Save.Input(service: item._id,
                                                      startDate: startDate,
                                                      endDate: endDate,
                                                      period: selectedPeriod.rawValue,
                                                      expiration: expiration)
            let response = try await usecase.saveAvailability(input: input)
            availability = response.availability

        } catch {
            handleError(error)
        }

    }
    
    @MainActor
    func deleteAvailability() async {
        let usecase = AvailabilityUseCase()
        
        do {
            let input = AvailabilityEntity.Delete.Input(_id: capsule.availabilityId)
            let response = try await usecase.deleteAvailability(input: input)
            availability = response.availability

        } catch {
            handleError(error)
        }
    }
    
    @MainActor
    func updateAvailability() async {
        let usecase = AvailabilityUseCase()
        
        do {
            let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            let expiration = doesExpyre ? selectedExpirationDate.endOfDay().toString(format: format) : nil
            let input = AvailabilityEntity.Update.Input(_id: capsule.availabilityId, startDate: selectedStartDate.toString(format: format), endDate: selectedEndDate.toString(format: format), period: selectedPeriod.rawValue, expiration: expiration)
            let response = try await usecase.updateAvailability(input: input)
            
            availability = response.availability

        } catch {
            handleError(error)
        }
    }
    
    func getWeekNames() -> [String] {
        let formatter = DateFormatter()
        var result: [String] = []
        let weekNames = formatter.weekdaySymbols
        for name in weekNames! {
            let refurbished = String(name.capitalized.prefix(3))
            result.append(refurbished)
        }
        
        return result
    }
    
}
