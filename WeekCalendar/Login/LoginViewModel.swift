//
//  LoginViewModel.swift
//  HayEquipo
//
//  Created by David Gomez on 30/04/2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    var alertTitle: String = "Login Error"
    var alertMessage: String = ""
    var alertButtonTitle: String = "OK"
    @Published var showAlert: Bool = false
    
    var loginUseCase = LoginUseCase()
    @Published var username: String = "diegodavid@icloud.com"
    @Published var password: String = "admin1234"
    @Published var onLoginSuccess: Bool = false

    @MainActor
    func doLogin() async {
        
        let input = LoginEntity.Input(email: username, password: password)
        do {
            let response = try await loginUseCase.doLogin(input: input)
            UserSessionManager.saveUser(user: response.user, token: response.token)
            onLoginSuccess = true
        } catch let error as APIError {
            self.showAlert = true
            alertMessage = error.description
        }
        catch  {
            self.showAlert = true
            alertMessage = error.localizedDescription
        }
    }
}
