//
//  HomeViewModel.swift
//  Weather
//
//  Created by habil . on 31/01/24.
//

import CoreLocation
import SwiftUI

@MainActor
final class HomeViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    let manager = CLLocationManager()
    @Published var latitude = ""
    @Published var longitude = ""
    @Published var address = ""
    
    var scrollView: ScrollViewProxy?
    let topModal = "TopModal"
    
    @Published var selected: Int = 0
    var initialIndex = -1
    var lastIndex = 0
    
    @Published var isDragging = false
    @Published var imageOffset: CGFloat = 0
    
    /*modal*/
    @Published var modalOffset: CGFloat = 657.5
    let modalTopPosition: CGFloat = 180
    let modalBottomPosition: CGFloat = 657.5
    
    /*title*/
    @Published var titleOffset: CGFloat = 0
    
    /*temperature font*/
    @Published var tempFontSize: CGFloat = 96
    let tempFontMinSize: CGFloat = 20
    let tempFontMaxSize: CGFloat = 96
    
    @Published var tempOffset: CGFloat = 0
    let tempOffsetMin: CGFloat = -70
    let tempOffsetMax: CGFloat = 0
    
    /*weather data*/
    @Published var weatherDataOffsetX: CGFloat = 0
    @Published var weatherDataOffsetY: CGFloat = -20
    let weatherDataOffsetMinX: CGFloat = 24.5
    let weatherDataOffsetMinY: CGFloat = -44
    let weatherDataOffsetMax: CGFloat = -20
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Published var networkState = NetworkState.initial
    @Published private(set) var homeError: HomeError?
    @Published var hasError = false
    @Published var forecast: Forecast?
    
    private let networkManager: NetworkManager!
    
    override init() {
        networkManager = NetworkManagerImpl.shared
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    var currentTemperature: String {
        forecast!.current.temperature2M.formatDouble
    }
    
    var maxTemperature: String {
        if let index = forecast!.daily.time.firstIndex(of: Date.now.formattedDateString) {
            return forecast!.daily.temperature2MMax[index].formatDouble
        } else {
            return 0.0.formatDouble
        }
    }
    
    var minTemperature: String {
        if let index = forecast!.daily.time.firstIndex(of: Date.now.formattedDateString) {
            return forecast!.daily.temperature2MMin[index].formatDouble
        } else {
            return 0.0.formatDouble
        }
    }
    
    var sunrise: String {
        //        if let index = forecast!.daily.time.firstIndex(of: Date.now.formattedDateString) {
        if let index = forecast!.daily.time.firstIndex(of: forecast!.hourly.time[selected].formattedDate) {
            return forecast!.daily.sunrise[index].sunFormatted
        } else {
            return 0.0.formatDouble
        }
    }
    
    var sunset: String {
        //        if let index = forecast!.daily.time.firstIndex(of: Date.now.formattedDateString) {
        if let index = forecast!.daily.time.firstIndex(of: forecast!.hourly.time[selected].formattedDate) {
            return forecast!.daily.sunset[index].sunFormatted
        } else {
            return 0.0.formatDouble
        }
    }
    
    func getForecast() async {
        withAnimation {
            networkState = .loading
        }
        
        do {
            forecast = try await networkManager.request(session: .shared, .getForecast(lat: latitude, long: longitude), type: Forecast.self)
            await getInitialForecast()
            withAnimation {
                networkState = .success
            }
        } catch {
            hasError = true
            withAnimation {
                networkState = .failed
            }
            
            switch error {
                
            case is NetworkManagerImpl.NetworkError:
                self.homeError = .networking(error: error as! NetworkManagerImpl.NetworkError)
            default:
                self.homeError = .system(error: error)
            }
        }
    }
    
    private func getInitialForecast() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let now = Date.now.formattedFullDateString
        
        if let referenceDate = dateFormatter.date(from: now) {
            _ = forecast!.hourly.time.enumerated().filter { index, now in
                if let date = dateFormatter.date(from: now) {
                    if date >= referenceDate && initialIndex == -1 {
                        selected = index
                        initialIndex = index
                    }
                    return date >= referenceDate
                }
                return false
            }
            
            lastIndex = initialIndex + 25
        } else {
            print("Error: Unable to convert reference date string to date")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lookUpCurrentLocation { placemark in
            if placemark != nil {
                self.address = placemark!
            }
            
            if let location = locations.first {
                self.latitude = location.coordinate.latitude.description
                self.longitude = location.coordinate.longitude.description
                
                self.manager.stopUpdatingLocation()
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (String?) -> Void){
        if let lastLocation = manager.location{
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation) { placemarks, error in
                if error == nil {
                    let firstLocation = placemarks?[0].locality
                    completionHandler(firstLocation)
                } else {
                    completionHandler(nil)
                }
            }
        } else {
            completionHandler(nil)
        }
    }
    
    func getWeatherType(from code: Int) -> WeatherType {
        WeatherType.fromWMO(code: code)
    }
    
    func requestLocationUpdate()async{
        manager.startUpdatingLocation()
    }
}

extension HomeViewModel {
    enum HomeError: LocalizedError {
        case networking(error: LocalizedError)
        case system(error: Error)
    }
}

extension HomeViewModel.HomeError {
    var errorDescription: String? {
        switch self {
        case .networking(let err):
            return err.errorDescription
        case .system(let err):
            return err.localizedDescription
        }
    }
}

extension HomeViewModel.HomeError: Equatable {
    static func == (lhs: HomeViewModel.HomeError, rhs: HomeViewModel.HomeError) -> Bool {
        switch (lhs, rhs) {
        case (.networking(let lhsType), .networking(let rhsType)):
            return lhsType.errorDescription == rhsType.errorDescription
        case (.system(let lhsType), .system(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
        default:
            return false
        }
    }
}
