//
//  Humidity.swift
//  Weather
//
//  Created by habil . on 02/02/24.
//

import SwiftUI

struct Humidity: View {
    let humidity: Int
    let dew: Double
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(humidity)%")
                .font(.title)
                .foregroundStyle(.white)
            
            Spacer()
            
            Text("The dew point is \(dew.formatDouble) right now.")
                .font(.subheadline)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
}

#Preview {
    Humidity(humidity: 90, dew: 1.4)
}
