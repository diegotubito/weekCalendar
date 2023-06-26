//
//  BaseViewModel.swift
//  HayEquipo
//
//  Created by David Gomez on 01/05/2023.
//

import Foundation

class BaseViewModel: ObservableObject{
    var alertTitle: String = ""
    var alertMessage: String = ""
    var alertButtonTitle: String = "OK"
    @Published var shouldNavigateToLogin: Bool = false
    @Published var showAlert: Bool = false
    
    @MainActor
    func handleError(_ error: Error) {
        self.showAlert = true
        if let customError = error as? APIError {
            switch customError {
            case .userSessionNotFound:
                shouldNavigateToLogin = true
                showAlert = false
            case .authentication:
                // need to handle login view
                shouldNavigateToLogin = true
                showAlert = false
                break
            default:
                break
            }
            let title = customError.title ?? "Error"
            let message = customError.message ?? "Error"
            self.alertTitle = title
            self.alertMessage = message

        } else {
            self.alertTitle = "Unkown Error"
            self.alertMessage = "Something went wrong"
        }
    }
}
