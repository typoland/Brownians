//
//  AngleRangesShape.swift
//  
//
//  Created by Łukasz Dziedzic on 06/11/2024.
//
import SwiftUI

public struct AngleRangesShape: Shape {
    var orbits: AnglesRanges 
    
    public init(orbits: AnglesRanges) {
        self.orbits = orbits
    }
    
    public func path(in rect: CGRect) -> Path {
        let half = rect.size.width/2
        let at = CGPoint(x: half + rect.origin.x,
                         y: rect.size.height/2 + rect.origin.y)
        return Path { path in
            if !orbits.isEmpty {
                for range in orbits.all {
                    path.move(to: at)
                    path.addArc(center: at, 
                                radius: half, 
                                startAngle: .radians(range.lowerBound), 
                                endAngle: .radians(range.upperBound), 
                                clockwise: false)
                    path.addLine(to: at)
                }
            }
        }
    }
}
