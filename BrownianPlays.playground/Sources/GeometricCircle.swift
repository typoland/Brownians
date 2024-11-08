//
//  GeometricCircle.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//

import Foundation
import SwiftUI

public struct GeometricCircle: Sendable {
    var at: CGPoint
    var r: Double
    public init(at: CGPoint, radius: Double) {
        self.at = at
        self.r = radius
    }
}

public enum CircleIntersection {
    case none
    case point(CGPoint)
    case points(CGPoint, CGPoint)
    
    public var view: some View {
        ZStack {
            switch self {
                
            case .points(let p1, let p2): 
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 5, height: 5)
                    .position(p1)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 5, height: 5)
                    .position(p2)
                
            case .point(let p1):
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 5, height: 5)
                    .position(p1)
                
            case .none:
                EmptyView()
            }
        }
    }
}

public extension GeometricCircle {
    static func * (lhs: Self, rhs: Self) -> CircleIntersection {
        let x1 = lhs.at.x
        let x2 = rhs.at.x
        let y1 = lhs.at.y
        let y2 = rhs.at.y
        let r1 = lhs.r
        let r2 = rhs.r
        
        let centerdx = x1 - x2
        let centerdy = y1 - y2
        let R = sqrt(centerdx * centerdx + centerdy * centerdy)
        if (!(abs(r1 - r2) <= R && R <= r1 + r2)) { // no intersection
            return .none; // empty list of results
        }
        // intersection(s) should exist
        
        let R2 = R*R
        let R4 = R2*R2
        let a = (r1*r1 - r2*r2) / (2 * R2);
        let r2r2 = (r1*r1 - r2*r2)
        let c = sqrt(2 * (r1*r1 + r2*r2) / R2 - (r2r2 * r2r2) / R4 - 1)
        
        let fx = (x1+x2) / 2 + a * (x2 - x1)
        let gx = c * (y2 - y1) / 2
        let ix1 = fx + gx
        let ix2 = fx - gx
        
        let fy = (y1+y2) / 2 + a * (y2 - y1)
        let gy = c * (x1 - x2) / 2
        let iy1 = fy + gy
        let iy2 = fy - gy
        let p1 = CGPoint(x: ix1, y: iy1)
        let p2 = CGPoint(x: ix2, y: iy2)
        // note if gy == 0 and gx == 0 then the circles are tangent and there is only one solution
        // but that one solution will just be duplicated as the code is currently written
        return p1 == p2 ? .point(p1) : {
            if case p1.onSide(of: lhs.at, and: rhs.at) = .up {
                return .points(p1 , p2)
            }
            return .points(p2, p1)
        }()
    }
    
    func contains(_ point: CGPoint) -> Bool {
        (point |-| at) < r
    }
}

