//
//  Visibility.swift
//  Weather
//
//  Created by habil . on 05/02/24.
//

import SwiftUI

struct Visibility: View {
    let visibility: Int
    
    var body: some View {
        VStack(alignment: .leading){
            Text(Double(visibility) / 1000, format: .number)+Text(" Km")
        }
        .font(.title)
        .foregroundStyle(.white)
        .padding(.horizontal)
    }
}

#Preview {
    Visibility(visibility: 1)
}
