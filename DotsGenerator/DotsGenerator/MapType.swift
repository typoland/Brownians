//
//  DetailMap.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage

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

enum MapTypeNames: String, CaseIterable, Codable {
    case image = "Image"
    case function = "Function"
}

enum MapType: Codable {
    
    enum MapCodingKeys: CodingKey {
        case filtersChain
        case function
    }
    
    enum MapTypeErrors: Error {
        case mapTypeKeyNotFound(String)
    }
    
    init(from decoder: any Decoder) throws {
        debugPrint("decoding MapType")
        let container = try decoder.container(keyedBy: MapCodingKeys.self)
        debugPrint("...Containeer \(container.allKeys)")
        if let chain = try? container.decode([Filter].self, forKey: .filtersChain) {
            print ("WTF", chain)
            self = .image(image: Defaults.ciImage, filters: FiltersChain(chain: chain))
            
        } else if let function = try? container.decode(Functions.self, forKey: .function) {
            self = .function(function)
            
        } else {
            print (container.allKeys)
            throw MapTypeErrors.mapTypeKeyNotFound("\(container.allKeys)")
        }
    }
    
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: MapCodingKeys.self)
        switch self {
        case .image(_, let filtersChain):
            try container.encode(filtersChain.chain, forKey: .filtersChain) 
        case .function(let functions):
            try container.encode(functions, forKey:. function) 
        }
    }
    
    case image(image: CIImage, filters: FiltersChain)
    case function(Functions)
    
    var name: String {
        switch self {
        case .image:
            return MapTypeNames.image.rawValue
        case .function:
            return MapTypeNames.function.rawValue
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
            return "Image \(image.extent), \(filters.chain.count) filters"
        case .function(let functions):
            return "Function \(functions)"
        }
    }
    
    
}
