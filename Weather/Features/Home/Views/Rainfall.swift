//
//  Rainfall.swift
//  Weather
//
//  Created by habil . on 02/02/24.
//

import SwiftUI

struct Rainfall: View {
    let rain: Double
    
    var body: some View {
        VStack(alignment: .leading){
            Text("\(rain.formatDouble) mm")
                .font(.title)
                .foregroundStyle(.white)
            
            Text("in last hour")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
}

#Preview {
    Rainfall(rain: 1.1)
}
