//
//  Filters.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage
import AppKit

enum Filters: CaseIterable, Identifiable, Equatable {
    typealias ID = String
    
    var id: String {
        self.name
    }
    enum Errors: Error {
        case noFilter(name: String)
    }
    
    static var allCases: [Filters] =
    [
        .gaussianBlur(radius: 10.0),
        .invert,
        .morfologyGradient(radius: 8),
        .colorMonochrome(color: NSColor.white, 
                         intensity: 2),
        .colorClamp(
            min: NSColor(red:0.0, green:0.0, blue:0.0, alpha: 0.0), 
            max: NSColor(red:1.0, green:1.0, blue:1.0, alpha: 1.0)),
        .enhancer(amount: 4.0)
       
        
    ]
    
    init (name: String) throws {
        guard let existing = Filters.allCases.first(where: {$0.name == name})
        else {throw (Errors.noFilter(name: name))}
        self = existing
    }
    
    
    var name: String {
        switch self {
        case .colorMonochrome:
            return "Color Monochrome"
        case .morfologyGradient:
            return "Morfology Gradient"
        case .colorClamp:
            return "Color Clamp"
        case .gaussianBlur:
            return "Gaussian Blur"
        case .invert:
            return "Invert"
        case .enhancer:
            return "Enchance"
        }
    }
    static var names: [String] {
        Filters.allCases.map {$0.name}
    }
    
    case colorMonochrome(color: NSColor, intensity: Double)
    case morfologyGradient(radius: Double)
    case colorClamp(min: NSColor, max: NSColor)
    case gaussianBlur(radius: Double)
    case invert
    case enhancer(amount: Double)
    
    func filter(image: CIImage) -> CIImage? {
        switch self {
        case .colorMonochrome(let color, let intensity):
            image.colorMonochrome(color: color, intensity: intensity)
        case .morfologyGradient(radius: let radius):
            image.morfologyGradient(radius: radius)
        case .colorClamp(min: let min, max: let max):
            image.colorClamp(min: min, max: max)
        case .gaussianBlur(radius: let radius):
            image.gaussianBlur(radius: radius)
        case .invert:
            image.colorInvert()
        case .enhancer(let amount):
            image.documentEnchancer(amount: amount)
        }
    }

}
