//
//  NeumorphicButton.swift
//  Weather
//
//  Created by habil . on 31/01/24.
//

import SwiftUI

struct NeumorphicButton: View {
    var isActive: Bool
    var time: String
    var degree: Double
    var image: String
    var action: () -> Void
    
    init(isActive: Bool, time: String, degree: Double, image: String, action: @escaping () -> Void) {
        self.isActive = isActive
        self.time = time
        self.degree = degree
        self.image = image
        self.action = action
    }
    
    var body: some View {
        Button(action: action){
            VStack(alignment: .center){
                Text(time.anteMeridiemFormatted)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(decorative: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                
                Spacer()
                
                Text("\(degree.formatDouble)°")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 16)
            .frame(width: 60, height: 146)
            .background(Color.activeColor.opacity(isActive ? 1 : 0.2))
            .clipShape(.capsule)
            .shadow(color: isActive ? Color.activeColor.opacity(0.55) : .black.opacity(0.5), radius: 20, x: 10, y: 10)
            .shadow(color: isActive ? Color.activeColor.opacity(0.55) : .black.opacity(0.5), radius: 20, x: -10, y: 0)
            .overlay(
                Capsule()
                    .stroke(.white.opacity(isActive ? 0.5 : 0.2), lineWidth: 1)
            )
            .padding(.vertical, 20)
        }
    }
}

#Preview {
    ZStack{
        Color.white
        
        NeumorphicButton(isActive: false, time: "NOW", degree: 19.9, image: Assets.sunny){}
    }
}
