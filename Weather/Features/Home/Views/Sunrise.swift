//
//  Sunrise.swift
//  Weather
//
//  Created by habil . on 01/02/24.
//

import SwiftUI

struct Sunrise: View {
    let sunrise: String
    let sunset: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(sunrise)
                .font(.title)
                .foregroundStyle(.white)
                .padding(.horizontal)
            
            ZStack{
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 40))
                    path.addQuadCurve(
                        to: CGPoint(x: 170, y: 40),
                        control: CGPoint(x: 85, y: -30)
                    )
                }
                .stroke(Color.gray, lineWidth: 4)
                .clipShape(.rect(cornerRadius: 10))
                
                Divider()
                    .frame(height: 1)
                    .background(.white.opacity(0.5))
                
                HStack{
                    Circle()
                        .fill(.white)
                        .frame(width: 10, height: 10)
                        .shadow(color: .white, radius: 5)
                        .shadow(color: .white, radius: 5)
                        .shadow(color: .white, radius: 5)
                    
                    Spacer()
                    
                    Circle()
                        .fill(.black)
                        .frame(width: 10, height: 10)
                        .shadow(color: .black, radius: 5)
                        .shadow(color: .black, radius: 5)
                        .shadow(color: .white, radius: 5)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            
            Text("Sunset: \(sunset)")
                .font(.subheadline)
                .foregroundStyle(.white)
                .padding(.horizontal)
        }
    }
}

#Preview {
    Sunrise(sunrise: "7:25 AM", sunset: "7:25 PM")
}
