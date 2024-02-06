//
//  Daily.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import Foundation

struct Daily: Codable {
    let time: [String]
    let temperature2MMax, temperature2MMin: [Double]
    let sunrise, sunset: [String]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
        case sunrise, sunset
    }
}
