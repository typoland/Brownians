//
//  AnglesRanges.swift
//  
//
//  Created by Łukasz Dziedzic on 06/11/2024.
//


import Foundation

public struct AnglesRanges: Sendable, CustomStringConvertible {
    var ranges: [ClosedRange<Double>] = []
    private static let sigma = 10000.0
    

    
    public mutating func add(from angleA: Double, to angleB: Double) {
        //print("add \(angleA.degrees) to \(angleB.degrees)")
            if angleA == angleB {return}
            let splited = angleA .<>. angleB
        //print("splited \(splited.map{$0.degrees})")
            for newRange in splited {
                let roundedRange = Double(round(newRange.lowerBound*AnglesRanges.sigma))/AnglesRanges.sigma...Double(round(newRange.upperBound*AnglesRanges.sigma))/AnglesRanges.sigma
                if ranges.filter({ $0.contains(range: roundedRange) }).isEmpty {
                    let coveredExistingIndexes = ranges.enumerated().compactMap {index, existingRange in
                        return roundedRange.contains(range: existingRange) 
                        ? index 
                        : nil
                    }
                    
                    for index in coveredExistingIndexes.reversed() {
                        ranges.remove(at: index)
                    }
                    
                    let start = roundedRange.lowerBound
                    let end =  roundedRange.upperBound
                    var changed = false
                    
                    if let existingStartIndex = ranges.firstIndex(where: {$0.contains(start)}) {
                        ranges[existingStartIndex] = ranges[existingStartIndex].lowerBound...end
                        changed = true
                    }
                    else 
                    if let existingStartIndex = ranges.firstIndex(where: {$0.contains(end)}) {
                        ranges[existingStartIndex] = start...ranges[existingStartIndex].upperBound
                        changed = true
                    } 
                    
                    
                    if !changed {
                        ranges.append(roundedRange)
                    }
                    ranges.sort()
                    
                    //Join overlaping
                    var i = ranges.count-1
                    while i > 0 {
                        if ranges[i-1].upperBound > ranges[i].lowerBound {
                            ranges[i-1] = ranges[i-1].lowerBound...ranges[i].upperBound
                            ranges.remove(at: i)
                            
                        }
                        i -= 1
                    }
                    //print ("added, now \(all.map {$0.degrees})")
            }
        }
    }
    
    public var isEmpty: Bool {
        return ranges.isEmpty
    }
    public var isFull: Bool {
        guard ranges.count == 1 else {return false}
        return ranges[0].lowerBound ==  ranges[0].upperBound - Double.tau
    }
    
    public func contains(_ value: Double) -> Bool {
        let value = value.closeIntoTau
        for range in ranges {
            if range.contains(value) {return true}
        }
        return false
    }
    
//    public mutating func remove(from angle1: Double, to angle2: Double) {
//        let rangesToRemove = angle1 .<>. angle2 
//        for rangeToRemove in rangesToRemove {
//            print (rangeToRemove)
//            let coveredIndexes = ranges.enumerated().compactMap {index, r in
//                return ranges.contains(range: r) ? index : nil
//            }
//            for index in coveredIndexes.reversed() {
//                ranges.remove(at:index) 
//            }
//            
//            let start = range.lowerBound
//            let end = range.upperBound
//            
//            if let existingStartIndex = ranges.firstIndex(where: {$0.contains(start)}) {
//                ranges[existingStartIndex] = ranges[existingStartIndex].lowerBound...start
//            }
//            
//            if let existingStartIndex = ranges.firstIndex(where: {$0.contains(end)}) {
//                ranges[existingStartIndex] = end...ranges[existingStartIndex].upperBound
//            }
//        }
//        
//    }
    public init() {
        self.ranges = []
    }
    
    public var description: String {
        let toDeg: (Double) -> String = { n in
            (n/Double.pi*180).formatted(.number.rounded(rule: .up, increment: 1)) + "°"
        }
        let output: ([ClosedRange<Double>]) -> String = { array in
            array.reduce (into: "orbits: ", {$0 += "\(toDeg($1.lowerBound)) — \(toDeg($1.upperBound)), "}) 
        }
                   
        if ranges.last?.upperBound == 2*Double.pi && ranges.first?.lowerBound == 0 && ranges.count > 1 {
            return "\(toDeg(ranges.last!.lowerBound)) - \(toDeg(ranges.first!.upperBound))𛰞" + output(Array(ranges[1..<ranges.count-1]))
        }
        return output(ranges)
    }
    
    var all: [ClosedRange<Double>] {
 
        if ranges.last?.upperBound == 2*Double.pi && ranges.first?.lowerBound == 0 && ranges.count > 1 {
            return [ranges.last!.lowerBound-Double.tau...ranges.first!.upperBound] + Array(ranges[1..<ranges.count-1])
        }
        return ranges
    }
}
import SwiftUI


public extension AnglesRanges {
    func view(color: Color = .red) -> some View {
        func gradient(color: Color) -> Gradient {
            Gradient(
                stops: [
                   // .init(color: .white.opacity(0.2), location: 0),
                    .init(color: color.opacity(0.0), location: 0.3),
                    .init(color: color.opacity(1.0), location: 1),
                ]
            )
        }
        return GeometryReader { proxy in
            AngleRangesShape(orbits: self)
                .fill(RadialGradient(
                    gradient: gradient(color: color),
                    center: .center,
                    startRadius: 0,
                    endRadius: proxy.size.width / 2
                ))
        }
    }
}
public extension ClosedRange where Bound: Comparable {
    func contains(range: Self) -> Bool {
        return self.lowerBound <= range.lowerBound && self.upperBound >= range.upperBound
    }
}

extension ClosedRange: @retroactive Comparable  
where Bound: Comparable {
    public static func < (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool {
        lhs.lowerBound < rhs.lowerBound
    }
}
