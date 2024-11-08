//
//  LineSegment.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//
import Foundation
import SwiftUI

public struct LineSegment: Sendable {
    public var p0: CGPoint
    public var p1: CGPoint
    
    public init (from: CGPoint, angle: Double, zone: ClosedRange<Double> ) {
        let cosA = cos(angle)
        let sinA = sin(angle)
        self.p0 = CGPoint(x: cosA*zone.lowerBound + from.x, y: sinA*zone.lowerBound + from.y)
        self.p1 = CGPoint(x: cosA*zone.upperBound + from.x, y: sinA*zone.upperBound + from.y)
    }
    
    public var view: some View {
        ZStack {
            LineSegmentShape(segment: self).stroke(Color.black, lineWidth: 1.2)
        }
    }
    
    static public func * (lhs: Self, rhs:Self) -> CGPoint? {
        let x1 = lhs.p0.x
        let x2 = lhs.p1.x
        let y1 = lhs.p0.y
        let y2 = lhs.p1.y
        let x3 = rhs.p0.x
        let x4 = rhs.p1.x
        let y3 = rhs.p0.y
        let y4 = rhs.p1.y
        
        
        let a_dx =  x2 - x1
        let a_dy = y2 - y1
        let b_dx = x4 - x3
        let b_dy = y4 - y3
        let s = (-a_dy * (x1 - x3) + a_dx * (y1 - y3)) / (-b_dx * a_dy + a_dx * b_dy)
        let t = (+b_dx * (y1 - y3) - b_dy * (x1 - x3)) / (-b_dx * a_dy + a_dx * b_dy)
        return (s >= 0 && s <= 1 && t >= 0 && t <= 1) ? CGPoint(x:x1 + t * a_dx, y: y1 + t * a_dy) : nil
    }
}
