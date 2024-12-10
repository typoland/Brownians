//
//  CGSize.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 20/11/2024.
//
import Foundation
extension CGSize {
    static func / (lhs: Self, rhs: Double) -> CGSize{
        return CGSize(width: lhs.width/rhs, height: lhs.height/rhs)
    }
    
    static func * (lhs: Self, rhs: Double) -> CGSize{
        return CGSize(width: lhs.width*rhs, height: lhs.height*rhs)
    }
}
