//
//  ApiNetworkMockAsync.swift
//  HayEquipo
//
//  Created by David Gomez on 10/04/2023.
//

import Foundation

open class ApiNetworkMockAsync {
    public var mockFileName: String = ""
    var success: Bool = true
    
    public init() {
    }
    
    var error: APIError?
    
    public func apiCallMocked<T: Decodable>(bundle: Bundle) async throws -> T {
        let filenameFromTestingTarget = ProcessInfo.processInfo.environment["FILENAME"] ?? ""
        if !filenameFromTestingTarget.isEmpty {
            mockFileName = filenameFromTestingTarget
        }
        
        let testFail = ProcessInfo.processInfo.arguments.contains("-testFail")
        if testFail {
            success = testFail
        }
        
        guard let data = readLocalFile(bundle: bundle, forName: mockFileName) else {
            throw APIError.jsonFileNotFound(filename: mockFileName)
        }
        
        if !success {
            throw APIError.mockFailed
        }
        
        guard let register = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIError.serialization
        }
        
        return register
    }
    
    private func readLocalFile(bundle: Bundle, forName name: String) -> Data? {
        guard let bundlePath = bundle.path(forResource: name, ofType: "json") else {
            return nil
        }
        
        return try? String(contentsOfFile: bundlePath).data(using: .utf8)
    }
    
}


