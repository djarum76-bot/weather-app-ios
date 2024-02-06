//
//  StringExtension.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import Foundation

extension String {
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            return outputFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    var anteMeridiemFormatted: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "h a"
            
            let formattedTimeString = outputFormatter.string(from: date)
            return formattedTimeString
        } else {
            return ""
        }
    }
    
    var sunFormatted: String {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        if let date = inputDateFormatter.date(from: self) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "h:mm a"
            let outputDateString = outputDateFormatter.string(from: date)
            return outputDateString
        } else {
            return ""
        }
    }
}
