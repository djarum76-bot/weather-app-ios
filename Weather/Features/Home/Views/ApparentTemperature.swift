//
//  ApparentTemperature.swift
//  Weather
//
//  Created by habil . on 02/02/24.
//

import SwiftUI

struct ApparentTemperature: View {
    let degree: Double
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(degree.formatDouble)°")
                .font(.title)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ApparentTemperature(degree: 18.9)
}
