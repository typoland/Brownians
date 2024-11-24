//
//  Filters.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage
import AppKit

enum Filter: CaseIterable, Identifiable, Equatable, Codable, Hashable {
    typealias ID = String
    
    var id: String {
        self.name
    }
    
    enum Errors: Error {
        case noFilter(name: String)
        case noCodingKey
    }
    
    static let allCases: [Filter] =
    [
        .gaussianBlur(radius: 10.0),
        .invert,
        .gamma(power: 2.0),
        .morfologyGradient(radius: 8),
        .colorMonochrome(color: NSColor.white, 
                         intensity: 2),
        .colorClamp(
            min: NSColor(red:0.0, green:0.0, blue:0.0, alpha: 0.0), 
            max: NSColor(red:1.0, green:1.0, blue:1.0, alpha: 1.0)),
        .enhancer(amount: 4.0)
    ]
    
    enum FilterCodingKeys: CodingKey {
        case colorMonochrome
        case morfologyGradient
        case colorClamp
        case gaussianBlur
        case invert
        case enchancer
        case gamma
    }
    
    init (name: String) throws {
        guard let existing = Filter.allCases.first(where: {$0.name == name})
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
        debugPrint ("init some Filter")
        let container = try decoder.container(keyedBy: FilterCodingKeys.self) 
        debugPrint ("...container: \(container.allKeys)")
        
        if let sub = try? container.nestedContainer(keyedBy: Monochrome.self, 
                                                    forKey: .colorMonochrome) {
            debugPrint("maybe Monochrome \(sub)")
            let colorArr = try sub.decode([Double].self, forKey: .color)
            let intesity = try sub.decode(Double.self, forKey: .intensity)
            self = .colorMonochrome(color: nsColor(colorArr), intensity: intesity)
            
            
        } else if let sub = try? container.nestedContainer(keyedBy: MorfologyGradient.self, 
                                                           forKey: .morfologyGradient) {
            debugPrint("maybe Morfology \(sub)")
            let radius = try sub.decode(Double.self, forKey: .radius)
            self = .morfologyGradient(radius: radius)
            
        } else  if let sub = try? container.nestedContainer(keyedBy: ColorClamp.self, 
                                                            forKey: .colorClamp) {
            debugPrint("maybe ColorClamp \(sub)")
            let min = try sub.decode([Double].self, forKey: .min)
            let max = try sub.decode([Double].self, forKey: .max)
            self = .colorClamp(min: nsColor(min), max: nsColor(max))
            
        } else  if let sub = try? container.nestedContainer(keyedBy: GaussianBlur.self, 
                                                            forKey: .gaussianBlur) {
            debugPrint("maybe Gaussian Blur \(sub)")
            let radius = try sub.decode(Double.self, forKey: .radius)
            self = .gaussianBlur(radius: radius)
            
        } else  if let sub = try? container.nestedContainer(keyedBy: Invert.self, 
                                                            forKey: .invert) {
            debugPrint("maybe Invert \(sub)")
            self = .invert
        } else if let sub = try? container.nestedContainer(keyedBy: GammaAdjust.self, 
                                                           forKey: .gamma) {
            let power = try sub.decode(Double.self, forKey: .power)
            self = .gamma(power: power)
        
        } else {
            debugPrint("ANY, Throw error")
            throw Errors.noCodingKey
        }
        debugPrint(self)
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
    
    enum GammaAdjust: CodingKey {
        case power
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
        
        var container = encoder.container(keyedBy: FilterCodingKeys.self)
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
        case .gamma(let power):
            var subContainer = container.nestedContainer(keyedBy: GammaAdjust.self,
                                                         forKey: .gamma) 
            try subContainer.encode(power, forKey: .power)
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
        case .gamma:
            return "Gamma"
        }
    }
    static var names: [String] {
        Filter.allCases.map {$0.name}
    }
    
    
    
    case colorMonochrome(color: NSColor, intensity: Double)
    case morfologyGradient(radius: Double)
    case colorClamp(min: NSColor, max: NSColor)
    case gaussianBlur(radius: Double)
    case invert
    case enhancer(amount: Double)
    case gamma(power: Double)
    
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
        case .gamma(let power):
            image.gammaAdjust(power: power)
        }
    }

}
