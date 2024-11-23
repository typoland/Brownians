//
//  DotSize.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 23/11/2024.
//


struct DotSize: Codable, CustomStringConvertible {
    var minSize: Double
    var maxSize: Double
   
    static func * (lhs: Self, rhs: Double) -> Double {
        (lhs.maxSize-lhs.minSize) * rhs + lhs.minSize //lerp
    }
    var description: String {
        "\(minSize)...\(maxSize)"
    }
}