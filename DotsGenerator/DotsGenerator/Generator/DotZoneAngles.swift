//
//  DotZoneAngles.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//


import Foundation
import SwiftUI

public struct DotZoneAngles: Sendable {

    public var `in`: Double 
    public var out: Double
    
    public var from: CGPoint
    
    init(in: Double, out: Double, from: CGPoint) {
        self.in = `in`
        self.out = out
        self.from = from
        //equalize()
    }
    public var random: Double {
        Double.random(in: range)
    }
    
    public var range: ClosedRange<Double> {
        `in` < out ? `in`...out : `in`...out + Double.tau
    }
}
