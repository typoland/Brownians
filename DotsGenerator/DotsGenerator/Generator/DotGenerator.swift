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
    
//    var size: CGSize
//    //public var dots: [Dot]
//    
//    public init(
//        size: CGSize,
//        resultDots: inout [Dot],
//        dotSize:     @escaping (CGPoint) -> Double, 
//        dotStrength: @escaping (CGPoint) -> Double 
//        
//    ) {
//            self.size = size
//            DotGenerator
//                .makeDots(in: size, 
//                          result: &resultDots,
//                          dotSize: dotSize, 
//                          dotStrength: dotStrength)
//        }
    
    static func makeDots(in size:CGSize,
                                 result: inout [Dot],
                                 dotSize: @escaping (CGPoint) -> Double, 
                                 dotStrength: @escaping (CGPoint) -> Double
    )  {
        
        //Do not start in same place
        let aroundMiddle: (CGSize) -> CGPoint = { size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let r = dotSize(center)
            return center + CGPoint(x: Double.random(in: -r...r),
                                    y: Double.random(in: -r...r))
        }
        //first dot somewhere in a middle
        let p = aroundMiddle(size)
        let dot = Dot(at: p, zone: dotSize(p), strength: dotStrength(p))
        
        
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
    }
}
