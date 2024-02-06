//
//  Endpoint.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import Foundation

enum Endpoint {
    case getForecast(lat: String, long: String)
}

extension Endpoint {
    enum MethodType: Equatable {
        case GET
    }
}

extension Endpoint {
    
    var host: String { "api.open-meteo.com" }
    
    var path: String {
        switch self {
        case .getForecast:
            return "/v1/forecast"
        }
    }
    
    var methodType: MethodType {
        switch self {
        case .getForecast:
            return .GET
        }
    }
    
    var queryItems: [String: String]? {
        switch self {
        case .getForecast(let lat, let long):
            return [
                "latitude":"\(lat)",
                "longitude":"\(long)",
                "current":"temperature_2m,weather_code",
                "hourly":"weather_code,temperature_2m,uv_index,wind_speed_10m,wind_direction_10m,rain,apparent_temperature,relative_humidity_2m,dew_point_2m,visibility",
                "daily":"temperature_2m_max,temperature_2m_min,sunrise,sunset",
                "timezone":"auto",
                "forecast_days":"3",
            ]
        }
    }
}

extension Endpoint {
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach { item in
            requestQueryItems.append(URLQueryItem(name: item.key, value: item.value))
        }
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}
