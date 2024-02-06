//
//  Current.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import Foundation

struct Current: Codable {
    let time: String
    let interval: Int
    let temperature2M: Double
    let weatherCode: Int

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case weatherCode = "weather_code"
    }
}
