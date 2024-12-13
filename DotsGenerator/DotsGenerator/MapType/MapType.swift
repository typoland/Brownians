//
//  DetailMap.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage
import AppKit
import SwiftUI



//enum MapTypeNames: String, CaseIterable, Codable {
//    case image = "Image"
//    case function = "Function"
//}



enum MapType: Codable {
    
    enum MapCodingKeys: CodingKey {
        case image
        case function
        case gradient
    }
    
    enum GradientType: String, CodingKey, Codable, CaseIterable  {
        case angular
        case eliptical
        case linear
    }
    
    enum ImageCodingKeys: CodingKey {
        case source
        case filters
    }
    
    enum GradientCodingKeys: CodingKey {
        case type
        case stops
        case data
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
            
        } else if let gradient = try? container.nestedContainer(keyedBy: GradientCodingKeys.self, forKey: .gradient) {
            let type = try gradient.decode(GradientType.self, forKey: .type)
            let stops = try gradient.decode([GradientStop].self, forKey: .stops)
            let data: any GradientData
            switch type {
            case .angular: 
                data = try gradient.decode(AngularGradientData.self, forKey: .data)
            case .eliptical:
                data = try gradient.decode(ElipticalGradientData.self, forKey: .data)
            case .linear:
                data = try gradient.decode(LinearGradientData.self, forKey: .data)
            }
                
            self = .gradient(type: type, stops: stops, data: data)
           
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
        case .gradient(type: let type, let stops, let data) :
            var sub = container.nestedContainer(keyedBy: GradientCodingKeys.self, forKey: .gradient)
            try sub.encode(type, forKey: .type)
            try sub.encode(stops, forKey: .stops) 
            try sub.encode(data, forKey: .data)
        }
    }
    
    case image(image: ImageSource, filters: FiltersChain)
    case function(function: CustomFunction)
    case gradient(type: GradientType, stops:[GradientStop], data:  any GradientData )
    
    init(index: Int) {
        switch index {
        case 0:  self = Defaults.defaultMapImage
        case 1: self = Defaults.defaultMapFunction
        case 2: self = Defaults.defaultDradient
        default: fatalError()
        }
    }
    
    //    init (_ name: String) {
    //        switch name {
    //        case MapTypeNames.image.rawValue : self = Defaults.defaultMapImage
    //        case MapTypeNames.function.rawValue: self = Defaults.defaultMapFunction
    //        default: self = Defaults.defaultMapValue
    //        }
    //    }
    
    @MainActor func faltten(to size: CGSize)  -> Self {
        switch self {
        case .image(let imageSource, let filters) :
            let flatten = (try? filters
                .result(source: imageSource).image
                .scaleTo(newSize: size)) ?? imageSource.image
            
            return .image(image: .flatten(flatten), 
                          filters: FiltersChain(chain:[]))
        case .gradient:
            let renderedGradient  =  image(size: size)
            let source = ImageSource.flatten(renderedGradient)
            return .image(image: source, 
                          filters: FiltersChain(chain:[]))
            
        default: return self
        }
    }
    
    @MainActor func image(size: CGSize)  -> CIImage {
        switch self {
            
        case .image(let image, _):
            
            return image.image
            
        case .function(function: let function):
            return  function.image(size: CGSize(width: 100, height: 100), 
                                   simulate: size)
            
        case .gradient(_, let stops, let data):
                let renderer = ImageRenderer(
                    content: RenderGradientView(size: size,
                                                stops: stops,
                                                data: data
                                               )
                )
            renderer.colorMode = .linear
            return renderer.nsImage?.ciImage ?? Defaults.image
               

        }
    }
}
