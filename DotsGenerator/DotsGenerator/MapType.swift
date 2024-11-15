//
//  DetailMap.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage

struct DotSize {
    var minSize: Double
    var maxSize: Double
   
    static func * (lhs: Self, rhs: Double) -> Double {
        (lhs.maxSize-lhs.minSize) * rhs + lhs.minSize //lerp
        //(rhs + lhs.minSize) * lhs.maxSize + lhs.minSize
    }
}

enum MapTypeNames: String, CaseIterable {
    case number = "Number"
    case image = "Image"
    case function = "Function"
}

enum MapType {
    
    case image(image: CIImage, filters: FiltersChain?, dotSize: DotSize)
    case function(Functions, dotSize: DotSize)
    case number(value: CGFloat)
    
    var name: String {
        switch self {
        case .image:
            return MapTypeNames.image.rawValue
        case .function:
            return MapTypeNames.function.rawValue
        case .number:
            return MapTypeNames.number.rawValue
        }
    }
    
    func value(at point:CGPoint, in size: CGSize) -> Double {
        switch self {
        case .image(let image, let chain, let dotSize):
            let gray = (try? chain?.result(source: image) ?? image)?.pixelColor(at: point).grayValue ?? 0.5
            return dotSize * gray
        case .function(let function, let dotSize):
            return dotSize * function.inSize(size)(point)
        case .number(let value):
            return value
        }
    }

    init (_ name: String) {
        switch name {
        case MapTypeNames.image.rawValue : self = Defaults.defaultMapImage
        case MapTypeNames.function.rawValue: self = Defaults.defaultMapFunction
        default: self = Defaults.defaultMapValue
        }
    }
    
    @MainActor
    func faltten(to size: CGSize) -> Self {
        if case .image(let image, let filters, let dotSize) = self {
            let flatten = (try? filters?.result(source: image)) ?? image.scaleTo(newSize: size)
            return .image(image: flatten, filters: nil, dotSize: dotSize)
        }
        return self
    }
}

extension MapType: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .image(let image, let filters, let dotSize):
            return "Image \(image) \(filters); Dot Sizes: \(dotSize)"
        case .function(let functions, let dotSize):
            return "Fuction \(functions); Dot Sizes: \(dotSize)"
        case .number(let value):
            return "Number \(value)"
        }
    }
    
    
}
