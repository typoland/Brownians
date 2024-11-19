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

actor DotGenerator: Sendable {
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
    
    
    
    func makeDotsTask(in jobSize: CGSize,
                      //result: inout [Dot],
                      detailMap: @escaping (CGPoint, CGSize) -> Double, 
                      dotSizeMap: @escaping (CGPoint, CGSize) -> Double,
                      chaos: Double,
                      startAt: CGPoint) async 
    
    -> Task<[Dot], Never>  
    
    {
        
        var generationNr = 0
        dots = []
#if DEBUG
        let start = Date.now
#endif
        
        return Task { () -> [Dot] in
            //Do not start in the same place
            
            let aroundMiddle: (CGSize) -> CGPoint = { size in
                let r = abs(detailMap(startAt, size))
                return startAt + CGPoint(x: Double.random(in: -r...r),
                                        y: Double.random(in: -r...r))
            }
            //first dot somewhere in a middle
            let p = aroundMiddle(jobSize)
            let dot = Dot(at: p, 
                          density: detailMap(p, jobSize), 
                          dotSize: dotSizeMap(p, jobSize))
            
            dots.append(dot)
            //make first dots around
            var newDots: [Dot] = await dot.addDots(in: jobSize, 
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
                        let z = await newDot.addDots(in: jobSize, 
                                                     generator: self,
                                                     density: detailMap,
                                                     dotSize: dotSizeMap,
                                                     chaos: chaos)
                        virginDots.append(contentsOf: z)
                    }
                    newDots = virginDots
                    generationNr += 1
#if DEBUG
                    let duration = Date.now.timeIntervalSince(start)
                    let s = duration.formatted(.number.precision(.fractionLength(16)))
                    print ("\(s)\t\(newDots.count)") 
#endif
                    await sendTemporaryResult()
                }
            } catch {
#if DEBUG
                print ("Genrator canceled")
#endif
              return dots
            }
#if DEBUG
            let duration = Date.now.timeIntervalSince(start)
            print ("Generator At the end Done \(dots.count) dots in \(generationNr) generations\ntime \(duration._0001) area: \(jobSize.width * jobSize.height)")
#endif
//            run = false
            return dots
            
            
        }
    }
}
