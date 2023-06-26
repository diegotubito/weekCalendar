//
//  ApiNetworkErrorModel.swift
//  HayEquipo
//
//  Created by David Gomez on 10/04/2023.
//

import Foundation

public enum APIError: Error, CustomStringConvertible {
    case customError(title: String?, message: String?)
    case badRequest(title: String?, message: String?)
    case invalidURL
    case invalidMethod(method: String?)
    case authentication
    case userSessionNotFound
    case notFound(url: String?)
    case rateLimitExceeded
    case serverError(message: String)
    case serialization
    case jsonFileNotFound(filename: String?)
    case mockFailed
    case imageFailed
    
    public var defaultDescription: String {
        return "\n🧨⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽💣⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽🚒\n"
    }
    
    public var defaultMessage: String {
        return ""
    }
    
    var code: Int {
        switch self {
        case .badRequest:
            return 400
        case .invalidURL:
            return 400
        case .invalidMethod(method: _):
            return 400
        case .authentication:
            return 401
        case .userSessionNotFound:
            return 401
        case .notFound(url: _):
            return 404
        case .rateLimitExceeded:
            return 432
        case .serverError:
            return 500
        case .serialization:
            return 400
        case .jsonFileNotFound(filename: _):
            return 405
        case .mockFailed:
            return 405
        case .customError(message: _):
            return 432
        case .imageFailed:
            return 400
        }
    }
    
    public var title: String? {
        switch self {
        case .badRequest(title: let title, message: _):
            return title
        case .customError(let title, message: _):
            return title
        case .invalidURL:
            return ""
        case .invalidMethod(_):
            return ""
        case .authentication:
            return ""
        case .userSessionNotFound:
            return ""
        case .notFound(_):
            return ""
        case .rateLimitExceeded:
            return ""
        case .serverError:
            return ""
        case .serialization:
            return ""
        case .jsonFileNotFound(_):
            return ""
        case .mockFailed:
            return ""
        case .imageFailed:
            return ""
        }
     }
    
    public var message: String? {
        switch self {
        case .badRequest(title: _, message: let message):
            return defaultMessage.appending("Bad request: \(message ?? "")")
        case .invalidURL:
            return defaultMessage.appending("Invalid URL")
        case .invalidMethod(method: let method):
            return defaultMessage.appending("Invalid http method \(method ?? "")")
        case .authentication:
            return defaultMessage.appending("Authentication failed")
        case .userSessionNotFound:
            return defaultMessage.appending("Need to login")
        case .notFound(let url):
            if let url = url {
                return defaultMessage.appending("code: \(code) - Resource not found: \(url)\n")
            } else {
                return defaultMessage.appending("Resource not found")
            }
        case .rateLimitExceeded:
            return defaultMessage.appending("Rate limit exceeded")
        case .serverError(message: let message):
            return defaultMessage.appending(message)
        case .serialization:
            return defaultMessage.appending("Serialization error")
        case .jsonFileNotFound(let filename):
            return defaultMessage.appending("Json file not found \(filename ?? "")")
        case .mockFailed:
            return defaultMessage.appending("Mock service force to fail")
        case .customError(title: _, message: let message):
            return message
        case .imageFailed:
            return defaultMessage.appending("Could not cast image from data. Bad format.")
        }
    }
        
    public var description: String {
        switch self {
        case .badRequest(message: let message):
            return defaultDescription.appending("Bad request: \(message)")
        case .invalidURL:
            return defaultDescription.appending("Invalid URL")
        case .invalidMethod(method: let method):
            return defaultDescription.appending("Invalid http method \(method ?? "")")
        case .authentication:
            return defaultDescription.appending("Authentication failed")
        case .userSessionNotFound:
            return defaultDescription.appending("Need to login.")
        case .notFound(let url):
            if let url = url {
                return defaultDescription.appending("code: \(code) - Resource not found: \(url)\n")
            } else {
                return defaultDescription.appending("Resource not found")
            }
        case .rateLimitExceeded:
            return defaultDescription.appending("Rate limit exceeded")
        case .serverError:
            return defaultDescription.appending("Server error")
        case .serialization:
            return defaultDescription.appending("Serialization error")
        case .jsonFileNotFound(let filename):
            return defaultDescription.appending("Json file not found \(filename ?? "")")
        case .mockFailed:
            return defaultDescription.appending("Mock service force to fail")
        case .customError(title: _, message: let message):
            return message ?? defaultDescription
        case .imageFailed:
            return defaultDescription.appending("Could not cast image from data. Bad format.")
        }
    }
}

