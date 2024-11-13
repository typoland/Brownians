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

    static func makeDots(in size: CGSize,
                         result: inout [Dot],
                         detailSize: @escaping (CGPoint) -> Double, 
                         dotSize: @escaping (CGPoint) -> Double,
                         chaos: Double
    )  {
        
        //Do not start in same place
        let aroundMiddle: (CGSize) -> CGPoint = { size in
            let center = CGPoint(x: size.width/2, y: size.height/2)
            let r = detailSize(center)
            return center + CGPoint(x: Double.random(in: -r...r),
                                    y: Double.random(in: -r...r))
        }
        print ("making dots in size:", size)
        //first dot somewhere in a middle
        let p = aroundMiddle(size)
        let dot = Dot(at: p, density: detailSize(p), dotSize: dotSize(p))
        
        
        //make first dots around
        var newDots: [Dot] = dot.addDots(in: size, 
                                         allDots: &result, 
                                         density: detailSize,
                                         dotSize: dotSize,
                                         chaos: chaos)
        
        var virginDots: [Dot] = []
        var counter = 0
        
        //reprat until all dots in frame
        while !newDots.isEmpty  {
            virginDots = []
            for newDot in newDots {
                autoreleasepool{
                    virginDots.append(
                        contentsOf: newDot.addDots(in: size, 
                                                   allDots: &result, 
                                                   density: detailSize,
                                                   dotSize: dotSize,
                                                   chaos: chaos))
                }
                newDots = virginDots
                
            }
            counter += 1
            print ("\(result.count) dots counted in \(counter) grnerations")
        }
    }
}
