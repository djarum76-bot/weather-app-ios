//
//  WeatherType.swift
//  Weather
//
//  Created by habil . on 06/02/24.
//

import Foundation

class WeatherType {
    let weatherDesc: String
    let image: String
    
    init(weatherDesc: String, image: String) {
        self.weatherDesc = weatherDesc
        self.image = image
    }
    
    static let clearSky = WeatherType(weatherDesc: "Clear sky", image: Assets.sunny)
    static let mainlyClear = WeatherType(weatherDesc: "Mainly clear", image: Assets.cloudy)
    static let partlyCloudy = WeatherType(weatherDesc: "Partly cloudy", image: Assets.cloudy)
    static let overcast = WeatherType(weatherDesc: "Overcast", image: Assets.cloudy)
    static let foggy = WeatherType(weatherDesc: "Foggy", image: Assets.veryCloudy)
    static let depositingRimeFog = WeatherType(weatherDesc: "Depositing rime fog", image: Assets.veryCloudy)
    static let lightDrizzle = WeatherType(weatherDesc: "Light drizzle", image: Assets.rainshower)
    static let moderateDrizzle = WeatherType(weatherDesc: "Moderate drizzle", image: Assets.rainshower)
    static let denseDrizzle = WeatherType(weatherDesc: "Dense drizzle", image: Assets.rainshower)
    static let lightFreezingDrizzle = WeatherType(weatherDesc: "Slight freezing drizzle", image: Assets.snowyrainy)
    static let denseFreezingDrizzle = WeatherType(weatherDesc: "Dense freezing drizzle", image: Assets.snowyrainy)
    static let slightRain = WeatherType(weatherDesc: "Slight rain", image: Assets.rainy)
    static let moderateRain = WeatherType(weatherDesc: "Rainy", image: Assets.rainy)
    static let heavyRain = WeatherType(weatherDesc: "Heavy rain", image: Assets.rainy)
    static let heavyFreezingRain = WeatherType(weatherDesc: "Heavy freezing rain", image: Assets.snowyrainy)
    static let slightSnowFall = WeatherType(weatherDesc: "Slight snow fall", image: Assets.snowy)
    static let moderateSnowFall = WeatherType(weatherDesc: "Moderate snow fall", image: Assets.heavysnow)
    static let heavySnowFall = WeatherType(weatherDesc: "Heavy snow fall", image: Assets.heavysnow)
    static let snowGrains = WeatherType(weatherDesc: "Snow grains", image: Assets.heavysnow)
    static let slightRainShowers = WeatherType(weatherDesc: "Slight rain showers", image: Assets.rainshower)
    static let moderateRainShowers = WeatherType(weatherDesc: "Moderate rain showers", image: Assets.rainshower)
    static let violentRainShowers = WeatherType(weatherDesc: "Violent rain showers", image: Assets.rainshower)
    static let slightSnowShowers = WeatherType(weatherDesc: "Light snow showers", image: Assets.snowy)
    static let heavySnowShowers = WeatherType(weatherDesc: "Heavy snow showers", image: Assets.snowy)
    static let moderateThunderstorm = WeatherType(weatherDesc: "Moderate thunderstorm", image: Assets.thunder)
    static let slightHailThunderstorm = WeatherType(weatherDesc: "Thunderstorm with slight hail", image: Assets.rainythunder)
    static let heavyHailThunderstorm = WeatherType(weatherDesc: "Thunderstorm with heavy hail", image: Assets.rainythunder)
    
    static func fromWMO(code: Int) -> WeatherType {
        switch code {
            case 0: return clearSky
            case 1: return mainlyClear
            case 2: return partlyCloudy
            case 3: return overcast
            case 45: return foggy
            case 48: return depositingRimeFog
            case 51: return lightDrizzle
            case 53: return moderateDrizzle
            case 55: return denseDrizzle
            case 56: return lightFreezingDrizzle
            case 57: return denseFreezingDrizzle
            case 61: return slightRain
            case 63: return moderateRain
            case 65: return heavyRain
            case 66: return lightFreezingDrizzle
            case 67: return heavyFreezingRain
            case 71: return slightSnowFall
            case 73: return moderateSnowFall
            case 75: return heavySnowFall
            case 77: return snowGrains
            case 80: return slightRainShowers
            case 81: return moderateRainShowers
            case 82: return violentRainShowers
            case 85: return slightSnowShowers
            case 86: return heavySnowShowers
            case 95: return moderateThunderstorm
            case 96: return slightHailThunderstorm
            case 99: return heavyHailThunderstorm
            default: return clearSky
        }
    }
}
