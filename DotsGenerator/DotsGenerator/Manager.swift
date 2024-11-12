//
//  Manager.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import Foundation
import CoreImage

@MainActor
class Manager : ObservableObject {
    
    struct DotSize {
        var multiplier: Double
        var minSize: Double
        static func * (lhs: Self, rhs: Double) -> Double{
            rhs * lhs.multiplier + lhs.minSize
        }
    }
    var size: CGSize = CGSize(width: 1024, height: 1024)
    var mainImage: CIImage? = nil
    @Published var detailMap: MapType = .number(value: 0.5)
    var detailDotSize = DotSize(multiplier: 50.0, minSize: 10.0)
    @Published var strengthMap: MapType = .number(value: 0.6)
    var strengthDotSize = DotSize(multiplier: 0.5, minSize: 0.1)
    @Published var dots: [Dot] = []
    
    
    func updateDots() {
        let imageDotSize: (CGPoint) -> Double =  { point in
            let gray = (try? self.detailMap.value(at: point)) ?? 0.5
            return self.detailDotSize * gray
        }
        let imageDotStrength: (CGPoint) -> Double =  { point in
            let gray = (try? self.strengthMap.value(at: point)) ?? 0.5
            return self.strengthDotSize * gray
        }
        
        dots = DotGenerator(size: size, 
                            dotSize: imageDotSize, 
                            dotStrength: imageDotStrength).dots
    }
    
    
}
