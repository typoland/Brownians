//
//  FloatingPoint.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//


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