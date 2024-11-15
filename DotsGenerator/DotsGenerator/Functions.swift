//
//  Functions.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 15/11/2024.
//
import Foundation
typealias DotFunction = (CGPoint) -> Double

enum Functions {
    case horizontalBlend
    case verticalBlend
    
    func inSize(_ size: CGSize) -> DotFunction {
        switch self {
        case .verticalBlend:
            return { (size.height-$0.y)/size.height }
        case .horizontalBlend:
            return { (size.width-$0.x)/size.width }
        }
    }
}
