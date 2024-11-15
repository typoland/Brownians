//
//  DotGenerator.swift
//  
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import Foundation
import AppKit



actor DotGenerator {
    
    enum Errors: Error {
        
        case success(with: [Dot])
        case failure(with: [Dot])
    }
    
    func addDot(_ dot:Dot) async {
        dots.append(dot)
    }
    var dots: [Dot] = []
//    var run: Bool = true
    func stop() {
        let t : Task<[Dot], Errors>  //= Task(operation: {[]})         
    }
    

    
    func makeDots(in size: CGSize,
                         //result: inout [Dot],
                         detailSize: @escaping (CGPoint) -> Double, 
                         dotSize: @escaping (CGPoint) -> Double,
                         chaos: Double ) async 
    
    -> Task<[Dot], Never>  
    
    {
        var counter = 0
        return Task { () -> [Dot] in
//            run = true
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
            dots = []
            
            //make first dots around
            var newDots: [Dot] = await dot.addDots(in: size, 
                                                   generator: self, 
                                                   density: detailSize,
                                                   dotSize: dotSize,
                                                   chaos: chaos)
            
            var virginDots: [Dot] = []
            
            
            //reprat until all dots in frame
//            print (!newDots.isEmpty, !(newDots.isEmpty && run))
            //let dotTask = Task {() -> Void in
            do {
                while !(newDots.isEmpty) {
                    try Task.checkCancellation()
                    virginDots = []
                    
                    for newDot in newDots {
                        //                autoreleasepool {
                        let z = await newDot.addDots(in: size, 
                                                     generator: self,
                                                     density: detailSize,
                                                     dotSize: dotSize,
                                                     chaos: chaos)
                        virginDots.append(contentsOf: z)
                    }
                    newDots = virginDots
                    print ("\(dots.count) dots counted in \(counter) generations")
                    counter += 1
                    // }
                }
            } catch {
                print ("Generator Canceled at \(counter)")
//                run = false
                return dots
            }

            print ("Generator At the end Done")
//            run = false
            return dots
            
            
        }
    }
}
