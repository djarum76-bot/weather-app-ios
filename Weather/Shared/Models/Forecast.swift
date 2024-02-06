//
//  Forecast.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import Foundation

struct Forecast: Codable {
    let current: Current
    let hourly: Hourly
    let daily: Daily
}
