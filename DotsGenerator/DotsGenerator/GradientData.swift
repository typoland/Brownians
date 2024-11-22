//
//  GradientData.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 22/11/2024.
//

import SwiftUI
struct GradientData: Codable, Hashable {
    
    struct GradientStop: Codable {
        
        enum StopColor : Int, Codable {
            case white = 1
            case black = 0
        }
        
        let color: StopColor
        let location: Double
    }
    
    var start: UnitPoint = UnitPoint(x: 0, y: 0)
    var end: UnitPoint = UnitPoint(x:1, y:1)
    var stops: [Gradient.Stop] = [
        Gradient.Stop(color: .white, location: 0),
        Gradient.Stop(color: .black, location: 1)
    ]
    init(){}
    enum Keys: CodingKey {
        case start
        case end
        case stops
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let start = try container.decode(CGPoint.self, forKey: .start)
        let end = try container.decode(CGPoint.self, forKey: .end)
        let stops = try container.decode([GradientStop].self, forKey: .stops)
        let s = stops.map{ GradientData.decodeStop($0)}
        self.start = UnitPoint(x: start.x, y: start.y)
        self.end = UnitPoint(x: end.x, y: end.y)
        self.stops = s
        
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(CGPoint(x: start.x, y: start.y), forKey: .start)
        try container.encode(CGPoint(x: end.x, y: end.y), forKey: .end)
        try container.encode(stops.map{GradientData.encodeStop($0)}, forKey: .stops)
    }
   
    
    static private func encodeStop(_ stop: Gradient.Stop) -> GradientStop {
       
        return GradientStop(color: stop.color == .white ? .white : .black, 
                            location: stop.location)
    } 
    
    static private func decodeStop(_ stop: GradientStop) -> Gradient.Stop {
        func color(from color: GradientStop.StopColor) -> Color {
            stop.color == .white ? .white : .black
        }
        return Gradient.Stop(color: color(from: stop.color), location: stop.location)
     
    }
}
