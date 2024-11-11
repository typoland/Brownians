//
//  CGPoint.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import Foundation
infix operator |-|

public extension CGPoint {
    
    static func - (lhs: Self, rhs: Self) -> Self {
        return CGPoint (x:lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        return CGPoint (x:lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func * (lhs: Self, rhs: Double) -> Self {
        return CGPoint (x:lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func |-| (lhs: Self, rhs: Self) -> Double {
        let o = rhs - lhs
        return sqrt(o.x.squared + o.y.squared)
    }
    
    func offset(angle: Double, distance: Double) -> CGPoint {
        return CGPoint(x: cos(angle) * distance + self.x,
                       y: sin(angle) * distance + self.y)
    }
    
    func onSide(of p1: CGPoint, and p2: CGPoint) -> Dot.ZoneSide {
        let dotsOffset = p2 - p1
        let middlePoint = (dotsOffset) * 0.5 + p1
        let dotsAngle = atan2(dotsOffset.y, dotsOffset.x)
        let toMiddle = self - middlePoint
        
        let angleToMiddle = atan2(toMiddle.y,toMiddle.x)
        return (angleToMiddle - dotsAngle).normalizedAngle < Double.pi ?
            .down : .up
    }
}

import SwiftUI
public extension CGPoint {
    var view: some View {
        Circle().fill(Color.yellow)
            .frame(width:18, height:18)
        
    }
}

