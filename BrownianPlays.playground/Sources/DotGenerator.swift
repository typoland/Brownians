//
//  DotGenerator.swift
//  
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import Foundation
import AppKit

@MainActor
public struct DotGenerator {
    
    var size: CGSize
    var draw: (CGContext, CGSize) -> Void
    public var dots: [Dot]
    
    public init(
        size: CGSize, 
        dotSize: @escaping (CGPoint) -> Double, 
        dotStrength: @escaping (CGPoint) -> Double, 
        draw: @escaping (CGContext, CGSize) -> Void) {
            self.size = size
            self.draw = draw
            self.dots = DotGenerator
                .makeDots(in: size, 
                          dotSize: dotSize, 
                          dotStrength: dotStrength)
        }
    
    private static func makeDots(in size:CGSize,
                                 dotSize: @escaping (CGPoint) -> Double, 
                                 dotStrength: @escaping (CGPoint) -> Double
    ) -> [Dot] {
        
        //Do not start in same place
        let aroundMiddle: (CGSize) -> CGPoint = { size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let r = dotSize(center)
            return center + CGPoint(x: Double.random(in: -r...r),
                                    y: Double.random(in: -r...r))
        }
        //first dot
        let p = aroundMiddle(size)
        let dot = Dot(at: p, zone: dotSize(p), strength: dotStrength(p))
        
        var result: [Dot] = [dot]
        //make first dots around
        var newDots: [Dot] = dot.addDots(in: size, 
                                         allDots: &result, 
                                         zoneClosure: dotSize,
                                         strengthClosure: dotStrength)
        
        var virginDots: [Dot] = []
        var counter = 0
        //reprat until all dots in frame
        while !newDots.isEmpty {
            virginDots = []
            for newDot in newDots {
                autoreleasepool{
                    virginDots.append(
                        contentsOf: newDot.addDots(in: size, 
                                                   allDots: &result, 
                                                   zoneClosure: dotSize,
                                                   strengthClosure: dotStrength))
                }
                print (counter, "new dots", virginDots.count)
                counter += 1
                newDots = virginDots
            }
        }
        return result
    }
}
