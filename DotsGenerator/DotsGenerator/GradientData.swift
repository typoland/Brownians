//
//  GradientData.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 22/11/2024.
//

import SwiftUI

protocol GradientData: Codable, Hashable {
    //associatedtype T: ShapeStyle
    //func style(with stops: [GradientStop]) -> T 
}

extension GradientData {
    func gradient(from stops: [GradientStop]) -> Gradient  {
        let gradientStops = stops.map { $0.gradient_stop }
        return Gradient(stops: gradientStops)
    }
}

struct GradientStop: Codable, Equatable, Hashable {
    
    enum StopColor : Int, Codable {
        case awhite = 1
        case ablack = 0
        var system: Color {
            switch self {
            case .awhite:
                return Color(white: 1)
            case .ablack:
                return Color(white: 0)
            }
        }
    }
    
    init(from gradient_stop: Gradient.Stop) {
        self.color = gradient_stop.color == .white ? .awhite : .ablack
        self.location = gradient_stop.location
    }
    init(color: StopColor, location: Double) {
        self.color = color
        self.location = location
    }
    var gradient_stop: Gradient.Stop {
        Gradient.Stop(color: color.system, 
                      location: location)
    }
    
    var color: StopColor
    var location: Double
}

struct AngularGradientData: GradientData {
    var center: UnitPoint = .center
    var startAngle: Double = 0
    var endAngle: Double = 180
    
    init(){}
    
    enum Keys: CodingKey {
        case center
        case startAngle
        case endAngle
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let center = try container.decode(CGPoint.self, forKey: .center)
        let end = try container.decode(Double.self, forKey: .endAngle)
        let start = try container.decode(Double.self, forKey: .startAngle)
        self.center = UnitPoint(x: center.x, y: center.y)
        self.startAngle = start
        self.endAngle = end
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(CGPoint(x: center.x, y: center.y), forKey: .center)
        try container.encode(endAngle, forKey: .endAngle)
        try container.encode(startAngle, forKey: .startAngle)
    }
}
struct LinearGradientData: GradientData {
    
    
    var start: UnitPoint = UnitPoint(x: 0, y: 0)
    var end: UnitPoint = UnitPoint(x:1, y:1)
     
    init(start: UnitPoint, end: UnitPoint){
        self.start = start
        self.end = end
    }
    init() {
        self.start = UnitPoint(x: 0, y: 0)
        self.end = UnitPoint(x: 1, y: 0)
    }
    
    enum Keys: CodingKey {
        case start
        case end
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let start = try container.decode(CGPoint.self, forKey: .start)
        let end = try container.decode(CGPoint.self, forKey: .end)
        self.start = UnitPoint(x: start.x, y: start.y)
        self.end = UnitPoint(x: end.x, y: end.y)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(CGPoint(x: start.x, y: start.y), forKey: .start)
        try container.encode(CGPoint(x: end.x, y: end.y), forKey: .end)
    }
}

struct ElipticalGradientData: GradientData {
    
    func style(with stops: [GradientStop]) -> EllipticalGradient {
        .ellipticalGradient(gradient(from: stops),
                                    center: center,
                                    startRadiusFraction: startRadiusFraction,
                                    endRadiusFraction: endRadiusFraction)
    }
    
    var center: UnitPoint = UnitPoint(x: 0.5, y: 0.5)
    var startRadiusFraction = 0.0
    var endRadiusFraction = 1.0
    enum Keys: CodingKey {
        case center
        case start
        case end
    }
    init(){}
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(CGPoint(x: center.x, y: center.y), forKey: .center)
        try container.encode(startRadiusFraction, forKey: .start)
        try container.encode(endRadiusFraction, forKey: .end)
    }
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let start = try container.decode(Double.self, forKey: .start)
        let end = try container.decode(Double.self, forKey: .end)
        let center = try container.decode(CGPoint.self, forKey: .center)
        self.startRadiusFraction = start
        self.endRadiusFraction = end
        
        self.center = UnitPoint(x: center.x, y: center.y)
    }
}
