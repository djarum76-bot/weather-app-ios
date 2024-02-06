//
//  StringExtension.swift
//  Weather
//
//  Created by habil . on 04/02/24.
//

import SwiftUI

extension Double{
    var formatDouble: String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = truncatingRemainder(dividingBy: 1.0) == 0 ? 0 : 1
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
