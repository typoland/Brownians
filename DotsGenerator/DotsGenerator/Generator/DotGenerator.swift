//
//  DotGenerator.swift
//  
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import Foundation
import AppKit
import Combine

//let updateGeneratorDots = PassthroughSubject<[Dot], Never>()

actor DotGenerator {
    @MainActor
    let updateGeneratorDots = PassthroughSubject<Void, Never>()
    
    func addDot(_ dot:Dot) async {
        dots.append(dot)
    }
    @MainActor
    func currentDots() async -> [Dot] {
        await dots
    }
    var dots: [Dot] = []
    
    @MainActor
    func sendTemporaryResult() {
        updateGeneratorDots.send()
    }
    
    func makeDotsTask(in size: CGSize,
                      //result: inout [Dot],
                      detailMap: @escaping (CGPoint, CGSize) -> Double, 
                      dotSizeMap: @escaping (CGPoint, CGSize) -> Double,
                      chaos: Double,
                      startAt: CGPoint?) async 
    
    -> Task<[Dot], Never>  
    
    {
        var generationNr = 0
        
        return Task { () -> [Dot] in
            //Do not start in the same place
            
            let aroundMiddle: (CGSize) -> CGPoint = { size in
                let center = startAt ?? CGPoint(x: size.width/2, y: size.height/2)
                let r = abs(detailMap(center, size))
                return center + CGPoint(x: Double.random(in: -r...r),
                                        y: Double.random(in: -r...r))
            }
            //first dot somewhere in a middle
            let p = aroundMiddle(size)
            let dot = Dot(at: p, 
                          density: detailMap(p, size), 
                          dotSize: dotSizeMap(p, size))
            dots = [dot]
            
            //make first dots around
            var newDots: [Dot] = await dot.addDots(in: size, 
                                                   generator: self, 
                                                   density: detailMap,
                                                   dotSize: dotSizeMap,
                                                   chaos: chaos)
            
            var virginDots: [Dot] = []

            do {
                while !(newDots.isEmpty) {
                    try Task.checkCancellation()
                    virginDots = []
                    
                    for newDot in newDots {
                        let z = await newDot.addDots(in: size, 
                                                     generator: self,
                                                     density: detailMap,
                                                     dotSize: dotSizeMap,
                                                     chaos: chaos)
                        virginDots.append(contentsOf: z)
                    }
                    newDots = virginDots
                    generationNr += 1
                    await sendTemporaryResult()
                }
            } catch {
              return dots
            }
#if DEBUG
            print ("Generator At the end Done \(dots.count) in \(generationNr) generations")
#endif
//            run = false
            return dots
            
            
        }
    }
}
