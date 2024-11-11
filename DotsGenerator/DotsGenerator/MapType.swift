//
//  DetailMap.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage

public enum MapType {
    
    case image(image: CIImage, filters: FiltersChain?)
    case function((CGPoint) -> Double)
    case none(value: CGFloat)
    
    @MainActor 
    public func value(at point:CGPoint) throws -> Double {
        switch self {
        case .image(let image, let chain):
            return (try chain?.result(source: image) ?? image).pixelColor(at: point).grayValue
        case .function(let function):
            return function(point)
        case .none(let value):
            return value
        }
    }
}
