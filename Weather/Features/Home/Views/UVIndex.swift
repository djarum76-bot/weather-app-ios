//
//  UVIndex.swift
//  Weather
//
//  Created by habil . on 01/02/24.
//

import SwiftUI

struct UVIndex: View {
    let value: Double
    var indicator: String{
        switch value {
        case 0..<3:
            "Low"
        case 3..<6:
            "Moderate"
        case 6..<8:
            "High"
        case 8..<11:
            "Very High"
        default:
            "Extreme"
        }
    }
    
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 1...20
    
    var body: some View {
        VStack(alignment: .leading){
            Text(value, format: .number)
                .font(.title)
                .foregroundStyle(.white)
            
            Text(indicator)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
            
            Spacer().frame(height: 10)
            
            GeometryReader { gr in
                let thumbSize = gr.size.height * 0.8
                let radius = gr.size.height * 0.5
                let minValue = gr.size.width * 0.015
                let maxValue = (gr.size.width * 0.98) - thumbSize
                
                let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
                let lower = sliderRange.lowerBound
                let sliderVal = (self.value - lower) * scaleFactor + minValue
                
                ZStack {
                    RoundedRectangle(cornerRadius: radius)
                        .foregroundStyle(
                            LinearGradient(stops: [
                                .init(color: .green, location: 1 / 20),
                                .init(color: .yellow, location: 3 / 20),
                                .init(color: .orange, location: 6 / 20),
                                .init(color: .red, location: 8 / 20),
                                .init(color: .purple, location: 11 / 20),
                            ], startPoint: .leading, endPoint: .trailing)
                        )
                    HStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: thumbSize, height: thumbSize)
                            .offset(x: sliderVal)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
}

#Preview {
    UVIndex(value: 5)
}
