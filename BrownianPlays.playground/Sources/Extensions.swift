//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 06/11/2024.
//

import Foundation

public extension ClosedRange where Bound == Double {
    var degrees: String {
        "\(lowerBound.degrees)...\(upperBound.degrees)"
    }
}
public extension FloatingPoint {
    var degrees: String {
        "\(deg._0001)°"
    }
    var deg: Self {
        self.normalizedAngle/Self.pi * 180 
    }
    var radians: Self {
        self*Self.pi / 180
    }
    var _0001: Self {
        (self * Self(Int(100.0))).rounded(.towardZero)/Self(Int(100.0))
    }
    var normalizedAngle: Self {
        let a = self.truncatingRemainder(dividingBy: Self.tau) 
        return a < 0 ? a + Self.tau : a
    }
    var squared: Self {
        return self*self
    }
    static var tau: Self {
        Self.pi * 2
    }
    
    var closeIntoTau: Self {
        let a = self.truncatingRemainder(dividingBy: Self.tau) 
        return a < 0 ? a + Self.tau : a
    }
}
//func upOrDown (p1: CGPoint, p2: CGPoint, ext: CGPoint) -> Dot.ZoneSide {
//    let dotsOffset = p2 - p1
//    let middlePoint = (dotsOffset) * 0.5 + p1
//    let dotsAngle = atan2(dotsOffset.y, dotsOffset.x)
//    let toMiddle = ext - middlePoint
//    
//    let angleToMiddle = atan2(toMiddle.y,toMiddle.x)
//    return (angleToMiddle - dotsAngle).normalizedAngle < Double.pi ?
//        .down : .up
//}

infix operator .<>.
//gives normalized angle counterclockwise range in positive values
public func .<>. (lhs: Double, rhs: Double) -> [ClosedRange<Double>] {
    if abs(rhs - lhs).truncatingRemainder(dividingBy: Double.tau) < 0.001 {return [0...Double.tau]}
    //let clockwise = lhs > rhs
 
    
    let a1 = lhs.truncatingRemainder(dividingBy: Double.tau).closeIntoTau
    let a2 = rhs.truncatingRemainder(dividingBy: Double.tau).closeIntoTau

    
    //print ("a1", a1.degrees, "a2", a2.degrees)
    return a1 > a2 ? [0.0...a2, a1...Double.tau]
    : [a1...a2]
    
}

import SwiftUI
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

public extension CGPoint {
    var view: some View {
        Circle().fill(Color.yellow)
            .frame(width:18, height:18)
        
    }
}

public extension CGSize {
    func contains(_ point:CGPoint) -> Bool {
        (0...width).contains(point.x)
        && (0...height).contains(point.y)
    }
}


public func someColor(index: Int) -> Color {
    if index == 0 {return .red}
    return .gray
//    return Color(red: Double.random(in: 0.1...0.8), 
//                 green: Double.random(in: 0.1...0.9), 
//                 blue: Double.random(in: 0.1...0.9))
    //return colors[Int.random(in: 0...index % colors.count)]
    //    return index >= colors.count
    //    ? Color(red: Double.random(in: 0.2...0.9),
    //            green: Double.random(in: 0.2...0.9),
    //            blue: Double.random(in: 0.2...0.9))
    //    : colors[index]
}
