//
//  DetailMap.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage

struct DotSize: Codable {
    var minSize: Double
    var maxSize: Double
   
    static func * (lhs: Self, rhs: Double) -> Double {
        (lhs.maxSize-lhs.minSize) * rhs + lhs.minSize //lerp
    }
}

enum MapTypeNames: String, CaseIterable, Codable {
    case number = "Number"
    case image = "Image"
    case function = "Function"
}

enum MapType: Codable {
    
    enum CodingKeys: CodingKey {
        case filtersChain
        case function
        case number
    }
    
    enum MapTypeErrors: Error {
        case mapTypeKeyNotFound(String)
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let chain = try? container.decode([Filters].self, forKey: .filtersChain) {
            print ("WTF", chain)
            self = .image(image: Defaults.ciImage, filters: FiltersChain(chain: chain))
        } else if let function = try? container.decode(Functions.self, forKey: .function) {
            self = .function(function)
        } else if let value = try? container.decode(Double.self, forKey: .number) {
            self = .number(value: value)
        } else {
            print (container.allKeys)
            throw MapTypeErrors.mapTypeKeyNotFound("\(container.allKeys)")
        }
    }
    
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .image(_, let filtersChain):
            try container.encode(filtersChain.chain, forKey: .filtersChain) 
        case .function(let functions):
            try container.encode(functions, forKey:. function) 
        case .number(let value):
            try container.encode(value, forKey: .number) 
        }
    }
    
    case image(image: CIImage, filters: FiltersChain)
    case function(Functions)
    case number(value: Double)
    
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
    
    init (_ name: String) {
        switch name {
        case MapTypeNames.image.rawValue : self = Defaults.defaultMapImage
        case MapTypeNames.function.rawValue: self = Defaults.defaultMapFunction
        default: self = Defaults.defaultMapValue
        }
    }
    
    func faltten(to size: CGSize) -> Self {
        if case .image(let image, let filters) = self {
            let flatten = (try? filters
                .result(source: image)
                .scaleTo(newSize: size)) ?? image
            
                .scaleTo(newSize: size)
            return .image(image: flatten, 
                          filters: FiltersChain(chain:[]))
        }
        return self
    }
}

extension MapType: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .image(let image, let filters):
            return "Image \(image) \(filters.chain.count) filters"
        case .function(let functions):
            return "Fuction \(functions)"
        case .number(let value):
            return "Number \(value)"
        }
    }
    
    
}
