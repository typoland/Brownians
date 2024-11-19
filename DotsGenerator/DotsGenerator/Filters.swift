//
//  Filters.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage
import AppKit

enum Filters: CaseIterable, Identifiable, Equatable, Codable {
    typealias ID = String
    
    var id: String {
        self.name
    }
    enum Errors: Error {
        case noFilter(name: String)
        case noCodingKey
    }
    
    static let allCases: [Filters] =
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
    
    enum MainCodingKeys: CodingKey {
        case colorMonochrome
        case morfologyGradient
        case colorClamp
        case gaussianBlur
        case invert
        case enchancer
    }
    
    init (name: String) throws {
        guard let existing = Filters.allCases.first(where: {$0.name == name})
        else {throw (Errors.noFilter(name: name))}
        self = existing
    }
    
    
    
    init(from decoder: any Decoder) throws {
        func nsColor(_ array: [Double]) -> NSColor {
            NSColor(red: array[0], 
                    green: array[1], 
                    blue: array[2], 
                    alpha: array[3])
        }
        let container = try decoder.container(keyedBy: MainCodingKeys.self) 
        
        if let sub = try? container.nestedContainer(keyedBy: Monochrome.self, 
                                                    forKey: .colorMonochrome) {
            let colorArr = try sub.decode([Double].self, forKey: .color)
            let intesity = try sub.decode(Double.self, forKey: .intensity)
            self = .colorMonochrome(color: nsColor(colorArr), intensity: intesity)
            
        } else  if let sub = try? decoder.container(keyedBy: MorfologyGradient.self) {
            let radius = try sub.decode(Double.self, forKey: .radius)
            self = .morfologyGradient(radius: radius)
            
        } else  if let sub = try? decoder.container(keyedBy: ColorClamp.self) {
            let min = try sub.decode([Double].self, forKey: .min)
            let max = try sub.decode([Double].self, forKey: .max)
            self = .colorClamp(min: nsColor(min), max: nsColor(max))
            
        } else  if let sub = try? decoder.container(keyedBy: GaussianBlur.self) {
            let radius = try sub.decode(Double.self, forKey: .radius)
            self = .gaussianBlur(radius: radius)
            
        } else  if let _ = try? decoder.container(keyedBy: Invert.self) {
            self = .invert
            
        } else {
            throw Errors.noCodingKey
        }
       
    }

    enum Monochrome: CodingKey {
        case color
        case intensity
    }
    enum MorfologyGradient: CodingKey {
        case radius
    }
    
    enum ColorClamp: CodingKey {
        case min
        case max
    }
    
    enum GaussianBlur: CodingKey {
        case radius
    }
    
    enum Invert: CodingKey {
        case yes
    }
    
    enum Enchancer: CodingKey {
        case amount
    }
    
    func encode(to encoder: any Encoder) throws {
        func rgba(_ color: NSColor) -> [Double] {
            let color = color.usingColorSpace(.genericRGB)!
            return [
                color.redComponent,
                color.greenComponent,
                color.blueComponent,
                color.alphaComponent
            ]
        }
        
        var container = encoder.container(keyedBy: MainCodingKeys.self)
        switch self {
            
        case .colorMonochrome(color: let color, intensity: let intensity):
            var subContainer = container.nestedContainer(keyedBy: Monochrome.self, 
                                                         forKey: .colorMonochrome)
            try subContainer.encode(rgba(color), forKey: .color)
            try subContainer.encode(intensity, forKey: .intensity)
            
        case .morfologyGradient(radius: let radius):
            var subContainer = container.nestedContainer(keyedBy: MorfologyGradient.self,
                                                         forKey: .morfologyGradient) 
            try subContainer.encode(radius, forKey: .radius)
            
        case .colorClamp(min: let min, max: let max):
            var subContainer = container.nestedContainer(keyedBy: ColorClamp.self,
                                                         forKey: .colorClamp) 
            try subContainer.encode(rgba(min), forKey: .min)
            try subContainer.encode(rgba(max), forKey: .max)
            
        case .gaussianBlur(radius: let radius):
            var subContainer = container.nestedContainer(keyedBy: GaussianBlur.self,
                                                         forKey: .gaussianBlur) 
            try subContainer.encode(radius, forKey: .radius)
        case .invert:
            var subContainer = container.nestedContainer(keyedBy: Invert.self,
                                                         forKey: .invert) 
            try subContainer.encode(true, forKey: .yes)
            
        case .enhancer(amount: let amount):
            var subContainer = container.nestedContainer(keyedBy: Enchancer.self,
                                                         forKey: .enchancer) 
            try subContainer.encode(amount, forKey: .amount)
        }
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
