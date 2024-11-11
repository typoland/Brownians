//
//  Dot.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//
import Foundation
import SwiftUI

@MainActor
public final class Dot: Sendable {
    public var zone: ClosedRange<Double> {
        lowerBound...upperBound 
    }
    
    public var at: CGPoint
    public let lowerBound : Double
    public let upperBound : Double
    public let strength : Double
    
    public var neighbors: [CGPoint] = []
    private var isFull: Bool = false

    public var innerCircle: GeometricCircle {
        GeometricCircle(at: at, radius: lowerBound)
    }
    public var outerCircle: GeometricCircle {
        GeometricCircle(at: at, radius: upperBound)
    }
    public var randomInZoneCircle: GeometricCircle  {
        GeometricCircle(at: at, radius: Double.random(in: zone))
    } 
    public init(at: CGPoint, zone: Double, strength: Double) {
        self.at = at
        self.lowerBound = 0.7 * zone //0.7 is OK
        self.upperBound = zone
        self.strength = strength
    }
    
    public enum ZoneSide: CaseIterable {
        case up
        case down
        case none
    }
    
    public func commonZone(with dot: Dot, contains point:CGPoint) -> ZoneSide {
        
        let  distanceToSelf =  zone.contains( point |-| at )
        //print ("\t\tSelf:", distanceToSelf, (zone/2...zone) , point |-| at)
        let  distanceToDot =  zone.contains( point |-| dot.at )
        //print ("\t\t Dot:", distanceToDot, (dot.zone/2...dot.zone) , point |-| dot.at)
        let side = point.onSide(of: at, and: dot.at)
        return distanceToSelf && distanceToDot  ? 
        side : .none
    }
    
    func zoneIsEmpty(with dot: Dot, for point: CGPoint, on side: ZoneSide, of dotsAround: [Dot] )  -> Bool {
        var otherDots = dotsAround
        
        if let index = dotsAround.firstIndex(where: {dot.at == $0.at}) {
            otherDots.remove(at: index)
         //   print ("removed \(index)")
        }
        
        //print ("other dots", otherDots.count)
        for otherDot in otherDots {
            if commonZone(with: dot, contains: otherDot.at) == side {
                //print ("Zone of \(self) and \(dot) is busy on \(side)")
                return false
            }
        }
        //print ("zone is empty on \(side)")
        return true
    }
    
    
    func addDots(in size: CGSize, 
                        allDots: inout [Dot], 
                        zoneClosure: (CGPoint) -> Double = {_ in 50.0},
                        strengthClosure:(CGPoint) -> Double = {_ in 0.5}) -> [Dot]  {
        //CHECK ZONES
        //var childDots: [Dot] = []
        var dotsAround = allDots.filter {dot in
            (dot.at |-| at) < (upperBound * lowerBound) && dot.at != at //&& !isFull
        }
        var newDots: [Dot] = []
        //print ("dots around:",dotsAround.count)
        //ADD first dot
        if dotsAround.isEmpty {
            let angle = Double.random(in: 0...Double.tau)
            let distance = Double.random(in: zone)
            let `where` = at.offset(angle: angle, distance: distance)
            let newDot = Dot(at: `where`, 
                             zone: zoneClosure(`where`),
                             strength: strengthClosure(`where`))
            dotsAround.append(newDot)
            allDots.append(newDot)
        } 

        var somethingAdded = true
        while somethingAdded  {

             somethingAdded = false
             search: for dot in dotsAround {

                    if case .points(let up, _) = randomInZoneCircle * dot.randomInZoneCircle {
                        let otherDots = dotsAround.filter({$0.at != dot.at}) 
                            
                        let inZoneOfOtherDots = otherDots.reduce(into: false, {$0 = $0 || $1.innerCircle.contains(up)}) 
                        let inFrame = (0...size.width).contains(up.x) && (0...size.height).contains(up.y)
                        
                        if zoneIsEmpty(with: dot, for: up, on: .up, of: dotsAround) && !inZoneOfOtherDots && inFrame {
                            let newDot = Dot(at: up, zone: zoneClosure(up), strength: strengthClosure(up))
                            allDots.append(newDot)
                            dotsAround.append(newDot)
                            newDots.append(newDot)
                            neighbors.append(newDot.at)
                            newDot.neighbors.append(at)
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
    
    func nextPoints(with dot: Dot) -> [CGPoint]  {
        
        let c1r =   self.randomInZoneCircle
        let c2r =    dot.randomInZoneCircle
        let c3r =   self.randomInZoneCircle
        let c4r =    dot.randomInZoneCircle
        let intersection1 = c1r * c2r
        let intersection2 = c3r * c4r
     
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
