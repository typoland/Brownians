//
//  DetailMap.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage
import AppKit

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

//enum MapTypeNames: String, CaseIterable, Codable {
//    case image = "Image"
//    case function = "Function"
//}



enum MapType: Codable {
    
    enum MapCodingKeys: CodingKey {
        case image
        case function
    }
    
    enum ImageCodingKeys: CodingKey {
        case source
        case filters
    }
    
    enum MapTypeErrors: Error {
        case mapTypeKeyNotFound(String)
    }
    
    init(from decoder: any Decoder) throws {
        debugPrint("decoding MapType")
        let container = try decoder.container(keyedBy: MapCodingKeys.self)
        debugPrint("...Containeer \(container.allKeys)")
        if let sub = try? container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image) {
            let source = try sub.decode(ImageSource.self, forKey: .source)
            let filters = try sub.decode(FiltersChain.self, forKey: .filters)
            
            self = .image(image: source, filters: filters)
            
        } else if let function = try? container.decode(CustomFunction.self, forKey: .function) {
            self = .function(function: function)
            
        } else {
            print (container.allKeys)
            throw MapTypeErrors.mapTypeKeyNotFound("\(container.allKeys)")
        }
    }
    
    
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: MapCodingKeys.self)
        switch self {
        case .image(let source, let filtersChain):
            var sub = container.nestedContainer(keyedBy: ImageCodingKeys.self, forKey: .image)
            try sub.encode(source, forKey: .source)
            try sub.encode(filtersChain, forKey: .filters) 
        case .function(let functions):
            try container.encode(functions, forKey:. function) 
        }
    }
    
    case image(image: ImageSource, filters: FiltersChain)
    case function(function: CustomFunction)
    

    
//    init (_ name: String) {
//        switch name {
//        case MapTypeNames.image.rawValue : self = Defaults.defaultMapImage
//        case MapTypeNames.function.rawValue: self = Defaults.defaultMapFunction
//        default: self = Defaults.defaultMapValue
//        }
//    }
    
    func faltten(to size: CGSize) -> Self {
        if case .image(let imageSource, let filters) = self {
            let flatten = (try? filters
                .result(source: imageSource).image
                .scaleTo(newSize: size)) ?? imageSource.image
            
            return .image(image: .flatten(flatten), 
                          filters: FiltersChain(chain:[]))
        }
        return self
    }
}



