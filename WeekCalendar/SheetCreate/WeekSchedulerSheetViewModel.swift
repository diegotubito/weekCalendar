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
                isEndless = true
            }
        }
    }
    @Published var availability: Availability?
    @Published var isEndless: Bool
    @Published var selectedExpirationDate: Date

    init(item: ItemModelPresenter, type: SheetType, capsule: SchedulerCapsuleModel) {
        self.item = item
        self.type = type
        self.capsule = capsule
        
        selectedStartDate = capsule.startDate.toDate()!
        selectedEndDate = capsule.endDate.toDate()!
        selectedPeriod = capsule.period
        isEndless = capsule.expiration == nil ? true : false
        selectedExpirationDate = capsule.expiration?.toDate() ?? capsule.endDate.toDate()!
    }
    
    @MainActor
    func saveAvailability() async {
        let usecase = AvailabilityUseCase()
        
        do {
            let format = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
            let expiration = isEndless ? nil : selectedExpirationDate.endOfDay().toString(format: format)
            let input = AvailabilityEntity.Save.Input(service: item._id, startDate: selectedStartDate.toString(format: format), endDate: selectedEndDate.toString(format: format), period: selectedPeriod.rawValue, expiration: expiration)
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
            let expiration = isEndless ? nil : selectedExpirationDate.endOfDay().toString(format: format)
            let input = AvailabilityEntity.Update.Input(_id: capsule.availabilityId, startDate: selectedStartDate.toString(format: format), endDate: selectedEndDate.toString(format: format), period: selectedPeriod.rawValue, expiration: expiration)
            let response = try await usecase.updateAvailability(input: input)
            
            availability = response.availability

        } catch {
            handleError(error)
        }
    }
}

