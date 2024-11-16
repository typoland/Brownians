//
//  Dot.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//
import Foundation
import SwiftUI


public final actor Dot: Sendable {
    public var zone: ClosedRange<Double> {
        lowerBound...upperBound 
    }
    
    public let at: CGPoint
    public let lowerBound : Double
    public let upperBound : Double
    public let dotSize : Double
    
    public var neighbors: [CGPoint] = []
    private var isFull: Bool = false

    private func innerCircle() async -> GeometricCircle {
        GeometricCircle(at: at, radius: lowerBound)
    }
    public func outerCircle() async -> GeometricCircle {
        GeometricCircle(at: at, radius: upperBound)
    }
    public func randomInZoneCircle() async -> GeometricCircle  {
        GeometricCircle(at: at, radius: Double.random(in: zone))
    } 
    
    public init(at: CGPoint, 
                density: Double, 
                dotSize: Double, 
                chaos: Double = 0.7) {
        
        self.at = at
        self.lowerBound = chaos * density //0.7 is OK
        self.upperBound = density
        self.dotSize = dotSize
    }
    
    public enum ZoneSide: CaseIterable {
        case up
        case down
        case none
    }
    
    public func commonZone(with dot: Dot, contains point:CGPoint) -> ZoneSide {
        
        let  distanceToSelf =  zone.contains( point |-| at )
        
        let  distanceToDot =  zone.contains( point |-| dot.at )

        let side = point.onSide(of: at, and: dot.at)
        return distanceToSelf && distanceToDot  ? 
        side : .none
    }
    func addNeibour(at: CGPoint) async {
        neighbors.append(at)
    }
    func zoneIsEmpty(with dot: Dot, for point: CGPoint, on side: ZoneSide, of dotsAround: [Dot] )  -> Bool {
        var otherDots = dotsAround
        
        if let index = dotsAround.firstIndex(where: {dot.at == $0.at}) {
            otherDots.remove(at: index)
        }
        
        for otherDot in otherDots {
            if commonZone(with: dot, contains: otherDot.at) == side {
                //print ("Zone of \(self) and \(dot) is busy on \(side)")
                return false
            }
        }
        return true
    }
    
    
    func addDots(in size: CGSize, 
                 generator: DotGenerator, 
                 density: (CGPoint, CGSize) -> Double,
                 dotSize: (CGPoint, CGSize) -> Double,
                 chaos: Double
    ) async -> [Dot]  {
        //CHECK ZONES
        var dotsAround = await generator.dots.filter {dot in
            (dot.at |-| at) < (upperBound * lowerBound) && dot.at != at //&& !isFull
        }
        var newDots: [Dot] = []
        //ADD first dot
        if dotsAround.isEmpty {
            let angle = Double.random(in: 0...Double.tau)
            let distance = Double.random(in: zone)
            let `where` = at.offset(angle: angle, distance: distance)
            let newDot = Dot(at: `where`, 
                             density: density(`where` , size),
                             dotSize: dotSize( `where`, size),
                             chaos: chaos)
            dotsAround.append(newDot)
            await generator.addDot(newDot)
        } 

        var somethingAdded = true
        while somethingAdded  {

             somethingAdded = false
             search: for dot in dotsAround {

                 if case .points(let up, _) = await randomInZoneCircle() * dot.randomInZoneCircle() {
                        let otherDots = dotsAround//.filter({$0.at != dot.at}) 
                     
                     
                     func thisDotTouches(_ dots: [Dot]) async -> Bool {
                         var inZoneOfOtherDots = false 
                         for otherDot in otherDots {
                             let inZone = await otherDot.innerCircle().contains(up)
                             inZoneOfOtherDots = inZoneOfOtherDots ||  inZone
                         }
                         return inZoneOfOtherDots
                     }
                     
                        let inFrame = (0...size.width).contains(up.x) && (0...size.height).contains(up.y)
                     let inZoneOfOtherDots = await thisDotTouches(otherDots)
                        if zoneIsEmpty(with: dot, for: up, on: .up, of: dotsAround) && !inZoneOfOtherDots && inFrame {
                            let newDot = Dot(at: up, 
                                             density: density(up, size), 
                                             dotSize: dotSize(up, size),
                                             chaos: chaos)
                            await generator.addDot(newDot)
                            dotsAround.append(newDot)
                            newDots.append(newDot)
                            neighbors.append(newDot.at)
                            await newDot.addNeibour(at: at)
                            somethingAdded = true
                            break search
                        }
                        
                }
            }

       }
        isFull = true
        //print ("\tAdded", newDots)
        return newDots

        
    }
//    public func addNeigbour (point: CGPoint)   {
//         neighbors.append(point)
//    }
    
    func nextPoints(with dot: Dot) async -> [CGPoint]  {
        
        let c1r =   self.randomInZoneCircle
        let c2r =    dot.randomInZoneCircle
        let c3r =   self.randomInZoneCircle
        let c4r =    dot.randomInZoneCircle
        let intersection1 = await c1r() * c2r()
        let intersection2 = await c3r() * c4r()
     
        let first: NSPoint?
        switch intersection1 {
        case .none : first = nil
        case .point(let a) : first = a
        case .points (let a, _): first = a
        }
        let second: NSPoint?
        switch intersection2 {
            case .none : second = nil
            case .point(let a) : second = a
        case .points ( _, let a): second = a
        }
        return [first, second].compactMap{$0}
    }
    
    
    func check(point: CGPoint, in first:(zone: ClosedRange<Double>, dotAngles: DotZoneAngles), 
               and second:(zone: ClosedRange<Double>, dotAngles: DotZoneAngles)) -> Bool {
        
        enum CheckAngleResult {
            case outside
            case inside
        }
        
        let  checkAngles: (CGPoint,  ClosedRange<Double>, DotZoneAngles) -> CheckAngleResult = {point, zone, angles in
            let offset = point - angles.from
            let angleFromDot = atan2(offset.y, offset.x)
            guard angles.in < angleFromDot 
                && angles.out > angleFromDot else {
                return .outside
            }
            
            let distance = sqrt (offset.x * offset.x + offset.y * offset.y)
            guard zone.contains(distance) else {
                return .outside
            }
            return .inside
        }  

        let results = (checkAngles(point, first.zone, first.dotAngles), 
                       checkAngles(point, second.zone, second.dotAngles))
        switch results {
        case (.inside, .inside): return true
        default: return false
        }
        
    }
    
    public var description: String  {
        "Dot at \(at.x._0001), \(at.y._0001)"
    }
}


extension Dot: @preconcurrency CustomStringConvertible {}
