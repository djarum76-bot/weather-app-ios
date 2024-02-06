//
//  ArrowShape.swift
//  Weather
//
//  Created by habil . on 02/02/24.
//

import SwiftUI

struct ArrowShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Define the proportion of the arrowhead to the tail
        let arrowWidth = rect.width * 0.4
        let arrowHeight = rect.height * 0.6

        // Draw the arrow tail
        path.move(to: CGPoint(x: rect.midX - arrowWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + arrowWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + arrowWidth / 2, y: rect.maxY - arrowHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - arrowHeight))

        // Draw the arrowhead
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - arrowHeight))
        path.addLine(to: CGPoint(x: rect.midX - arrowWidth / 2, y: rect.maxY - arrowHeight))

        // Complete the path by closing the shape
        path.closeSubpath()

        return path
    }
}
