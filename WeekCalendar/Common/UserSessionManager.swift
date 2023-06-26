//
//  UserSessionManager.swift
//  HayEquipo
//
//  Created by David Gomez on 01/05/2023.
//

import Foundation

struct UserSessionModel: Codable {
    let user: User
    let token: String
}

extension UserSessionModel {

}

class UserSessionManager {
    static let shared = UserSessionManager()
    static private let userSessionKey = "UserSessionKey"
    static private let deviceTokenKey = "DeviceToken"
    
    static func saveUser(user: User, token: String) {
        do {
            let userSession = UserSessionModel(user: user, token: token)
            let encoder = JSONEncoder()
            let data = try encoder.encode(userSession)
            _ = KeychainManager.shared.save(key: userSessionKey, data: data)
        } catch {
            print("Error encoding person: \(error)")
        }
        
    }
    
    static func getUserSession() -> UserSessionModel? {
        do {
            if let data = KeychainManager.shared.load(key: userSessionKey) {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserSessionModel.self, from: data)
                return user
            }
            return nil
        } catch {
            return nil
        }
    }
    
    static func getToken() -> String? {
        do {
            if let data = KeychainManager.shared.load(key: userSessionKey) {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserSessionModel.self, from: data)
                return user.token
            }
            return nil
        } catch {
            return nil
        }
    }
    
    static func removeUserSession() {
        let _ = KeychainManager.shared.delete(key: userSessionKey)
    }
    
    static func saveDeviceToken(data: Data) {
        _ = KeychainManager.shared.save(key: deviceTokenKey, data: data)
    }
    
    static func getDeviceToken() -> String? {
        guard let deviceTokenData = KeychainManager.shared.load(key: deviceTokenKey) else {
            return nil
        }
        
        let tokenString = deviceTokenData.reduce("", { $0 + String(format: "%02X", $1) })
        return tokenString
    }
}

