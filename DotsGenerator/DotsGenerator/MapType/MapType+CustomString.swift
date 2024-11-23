//
//  MapType+CustomString.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 19/11/2024.
//


extension MapType: CustomDebugStringConvertible {
    
    var debugDescription: String {
        switch self {
        case .image(let image, let filters):
            return "Image \(image), \(filters.chain.count) filters"
        case .function(let functions):
            return "Function \(functions)"
        case .gradient(let type, let stops, let data):
            return "Gradient \(type) \(stops.count) stops \(data)"
        }
    }
}
