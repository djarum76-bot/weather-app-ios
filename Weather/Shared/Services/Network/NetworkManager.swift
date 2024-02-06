//
//  NetworkManager.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import Foundation

protocol NetworkManager {
    func request<T: Codable>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T
}

final class NetworkManagerImpl: NetworkManager{
    static let shared = NetworkManagerImpl()
    
    private init() {}
    
    func request<T: Codable>(session: URLSession, _ endpoint: Endpoint, type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidUrl
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await session.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        let res = try decoder.decode(T.self, from: data)
        
        return res
    }
}

extension NetworkManagerImpl {
    enum NetworkError: LocalizedError {
        case invalidUrl
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension NetworkManagerImpl.NetworkError: Equatable {
    
    static func == (lhs: NetworkManagerImpl.NetworkError, rhs: NetworkManagerImpl.NetworkError) -> Bool {
        switch(lhs, rhs) {
        case (.invalidUrl, .invalidUrl):
            return true
        case (.custom(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
            return lhsType == rhsType
        case (.invalidData, .invalidData):
            return true
        case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}

extension NetworkManagerImpl.NetworkError {
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL isn't valid"
        case .invalidStatusCode:
            return "Status code falls into the wrong range"
        case .invalidData:
            return "Response data is invalid"
        case .failedToDecode:
            return "Failed to decode"
        case .custom(let err):
            return "Something went wrong \(err.localizedDescription)"
        }
    }
}

private extension NetworkManagerImpl {
    func buildRequest(from url: URL, methodType: Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)
        
        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
