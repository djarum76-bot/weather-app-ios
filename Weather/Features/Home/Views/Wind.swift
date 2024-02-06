//
//  Wind.swift
//  Weather
//
//  Created by habil . on 02/02/24.
//

import SwiftUI

struct Wind: View {
    let degrees = Array(stride(from: 0, through: 359, by: 3))
    let speed: Double
    let direction: Int
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                ForEach(degrees, id: \.self) { degree in
                    ZStack{
                        Capsule()
                            .frame(width: degree % 30 == 0 ? 1 : 0.5,height: 8)
                            .foregroundStyle(degree % 30 == 0 ? .white.opacity(degree % 90 == 0 ? 1 : 0.6) : .gray)
                            .padding(.bottom, 100)
                            .rotationEffect(Angle(degrees: Double(degree)))
                        
                        Text(generateDirection(degree: degree))
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white)
                            .rotationEffect(Angle(degrees: Double(0 - degree)))
                            .padding(.bottom, 72.5)
                            .rotationEffect(Angle(degrees: Double(degree)))
                        
                        VStack(alignment: .center){
                            Text(speed, format: .number)
                                .font(.title3)
                                .foregroundStyle(.white)
                            
                            Text("Km/h")
                                .font(.system(size: 12))
                                .foregroundStyle(.white)
                        }
                        
                        ArrowShape()
                            .fill(.white)
                            .frame(width: 8, height: 30)
                            .aspectRatio(1, contentMode: .fit)
                            .padding(.bottom, 80)
                            .rotationEffect(Angle(degrees: Double(direction)))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 75)
            .rotationEffect(Angle(degrees: 0)) // 3
            .statusBar(hidden: true)
            
            Spacer()
        }
    }
    
    func generateDirection(degree: Int) -> String{
        switch degree {
        case 0:
            "N"
        case 90:
            "E"
        case 180:
            "S"
        case 270:
            "W"
        default:
            ""
        }
    }
}

#Preview {
    Wind(speed: 10.2, direction: 189)
}
