//
//  ServiceApi.swift
//  HayEquipo
//
//  Created by David Gomez on 09/04/2023.
//
import Foundation

open class ApiNetwork {
    public var config: ApiRequestConfiguration
    let session: URLSession
    
    public init() {
        config = ApiRequestConfiguration()
        session = URLSession(configuration: .default)
    }
    
    public func apiCall<T: Decodable>(completion: @escaping (Result<T, APIError>) -> Void) {
        performRequest { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let data):
                do {
                    // If T is of type Data, return the data directly without decoding
                    if T.self == Data.self {
                        return completion(.success(data as! T))
                    }
                    
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let genericData = try decoder.decode(T.self, from: data)
                    completion(.success(genericData))
                } catch {
                    completion(.failure(.serialization))
                }
            }
        }
    }
   
    private func performRequest(completion: @escaping (Result<Data, APIError>) -> Void) {
        let request = createRequest()
        doTask(request: request, completion: completion)
    }
    
    private func createRequest() -> URLRequest {
        guard let url = config.getUrl(), let method = config.method else {
            fatalError("URL or Method is missing.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      
        if let token = UserSessionManager.getToken() {
            let authorization = "Bearer \(token)"
            request.addValue(authorization, forHTTPHeaderField: "Authorization")
        }
        
        for header in config.headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        if let body = config.body {
            request.httpBody = body
        }
        
        return request
    }
    
    private func doTask(request: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) {
        if UserSessionManager.getUserSession() == nil && config.userIsNeeded  {
            completion(.failure(.userSessionNotFound))
            return
        }

        let task = session.dataTask(with: request) {(data, response, error) in
            if error != nil {
                completion(.failure(.serverError(message: "Unknown error")))
                return
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.notFound(url: request.url?.absoluteString)))
                return
            }
            
            let status = response.statusCode
            guard (200...299).contains(status) else {
                if status == 404 {
                    completion(.failure(.notFound(url: request.url?.absoluteString)))
                } else if status == 401 {
                    /*    if self.retry > 0 {
                     self.retry -= 1
                     self.refreshJWT(request: request, completion: completion)
                     } else {
                     completion(.failure(.notAuthorized))
                     }
                     */
                }
                else if status == 500 {
                    completion(.failure(.serverError(message: "show be error message here")))
                } else {
                    completion(.failure(.serverError(message: "unknow error")))
                }
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
