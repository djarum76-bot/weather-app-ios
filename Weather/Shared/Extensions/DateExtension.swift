//
//  DateExtension.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import Foundation

extension Date{
    var formattedDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var formattedFullDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:'00'"
        return dateFormatter.string(from: self)
    }
    
    var formattedDateHourString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH"
        return dateFormatter.string(from: self)
    }
}
