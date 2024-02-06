//
//  Hourly.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import Foundation

struct Hourly: Codable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2M, uvIndex, windSpeed10M: [Double]
    let windDirection10M: [Int]
    let rain, apparentTemperature: [Double]
    let relativeHumidity2M: [Int]
    let dewPoint2M: [Double]
    let visibility: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2M = "temperature_2m"
        case uvIndex = "uv_index"
        case windSpeed10M = "wind_speed_10m"
        case windDirection10M = "wind_direction_10m"
        case rain
        case apparentTemperature = "apparent_temperature"
        case relativeHumidity2M = "relative_humidity_2m"
        case dewPoint2M = "dew_point_2m"
        case visibility
    }
}
