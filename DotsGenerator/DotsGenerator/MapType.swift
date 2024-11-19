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

enum MapTypeNames: String, CaseIterable, Codable {
    case image = "Image"
    case function = "Function"
}

enum ImageSource: Codable {
    enum Er: Error {
        case importFailed
        case cannotSaveFlatten
    }
    case url(url: URL)
    case local(name: String)
    case flatten(CIImage)
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        if let url = try? container.decode(URL.self, forKey: .url) {
            self = .url(url: url)
        } else if let name = try? container.decode(String.self, forKey: .local) {
            self = .local(name: name)
        } else {
            throw Er.importFailed
        }
    }
    enum Keys: CodingKey {
        case url
        case local
        case flatten
    }
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        switch self {
        case .url(let url):
           try container.encode(url, forKey: .url)
        case .local(let name):
            try container.encode(name, forKey: .local)
        case .flatten(let cIImage):
            throw Er.cannotSaveFlatten
        }
    }
    var image: CIImage {
        switch self {
        case .url(let url):
            return NSImage(contentsOf: url)?.ciImage ?? Defaults.imageSource.image
        case .local(let name):
            return NSImage(named: name)!.ciImage ?? Defaults.imageSource.image
        case .flatten(let ciImage):
            return ciImage
        }
        
    }
}

enum MapType: Codable {
    
    enum MapCodingKeys: CodingKey {
        case image
        case function
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
            
        } else if let function = try? container.decode(Functions.self, forKey: .function) {
            self = .function(function)
            
        } else {
            print (container.allKeys)
            throw MapTypeErrors.mapTypeKeyNotFound("\(container.allKeys)")
        }
    }
    enum ImageCodingKeys: CodingKey {
        case source
        case filters
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

extension MapType: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .image(let image, let filters):
            return "Image \(image), \(filters.chain.count) filters"
        case .function(let functions):
            return "Function \(functions)"
        }
    }
    
    
}
