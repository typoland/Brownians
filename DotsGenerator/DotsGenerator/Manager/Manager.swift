//
//  Manager.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import Foundation
import CoreImage
import Combine
import SwiftUI

@MainActor
class Manager: ObservableObject, @preconcurrency Codable {
    
    enum SizeOwner : String, Codable {
        case manager
        case detailMap
        case sizeMap
    }
    
    @Published var sizeOwner: SizeOwner = .manager
    @Published var finalSize: CGSize = CGSize(width: 800, height: 600)
    @Published var detailMap: MapType = Defaults.defaultMapImage
    @Published var sizeMap: MapType = Defaults.defaultMapImage
    @Published var detailSize = DotSize(minSize: 4, maxSize: 6)
    @Published var dotSize = DotSize(minSize: 0.2, maxSize: 0.7)
    @Published var dots: [Dot] = []
    @Published var chaos: Double = 0.7
    @Published var resultsFolderPath: URL? = nil
    
    @Published var rotationMap: MapType = Defaults.defaultMapRotation
    @Published var rotationLimits = DotSize(minSize: 0, maxSize: Double.tau)
    @Published var dotShape: any Shape = CircleShape(dot: Dot()) 
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sizeOwner = try container.decode(SizeOwner.self, forKey: .sizeOwner)
        self.finalSize = try container.decode(CGSize.self, forKey: .finalSize)
        self.detailMap = try container.decode(MapType.self, forKey: .detailMap)
        self.sizeMap = try container.decode(MapType.self, forKey: .sizeMap)
        self.detailSize = try container.decode(DotSize.self, forKey: .detailSize)
        self.dotSize = try container.decode(DotSize.self, forKey: .dotSize)
        self.chaos = try container.decode(Double.self, forKey: .chaos)
        
        self.rotationMap = try container.decode(MapType.self, forKey: .rotationMap)
        self.rotationLimits = try container.decode(DotSize.self, forKey: .rotationLimits)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sizeOwner, forKey: .sizeOwner)
        try container.encode(finalSize, forKey: .finalSize)
        try container.encode(detailMap, forKey: .detailMap)
        try container.encode(sizeMap, forKey: .sizeMap)
        try container.encode(detailSize, forKey: .detailSize)
        try container.encode(dotSize, forKey: .dotSize)
        try container.encode(chaos, forKey: .chaos)
        
        try container.encode(rotationLimits, forKey: .rotationLimits)
        try container.encode(rotationMap, forKey: .rotationMap)
    }
    
    enum CodingKeys: CodingKey {
        case sizeOwner
        case finalSize
        case detailMap
        case sizeMap
        case detailSize
        case dotSize
        case dots
        case chaos
        
        case rotationMap
        case rotationLimits
            
    }
    
    func update(from manager: Manager) {
        sizeOwner = manager.sizeOwner
        finalSize = manager.finalSize
        detailMap = manager.detailMap
        sizeMap = manager.sizeMap
        detailSize = manager.detailSize
        dotSize = manager.dotSize
        rotationMap = manager.rotationMap
        rotationLimits = manager.rotationLimits
        dots = []
        chaos = manager.chaos
    }
    
    init () {}
     
    private func mapValue(map: MapType, dotSize: DotSize, in size: CGSize) -> (CGPoint, CGSize) -> Double {
        let valueCount : (CGPoint, CGSize) ->Double
        let map = map.faltten(to: size)
        switch map {
            
        case .image(image: let source, _):
            let grayMap = source.image.grayMap          
            valueCount =  {point, _ in grayMap.value(at: point, for: dotSize.maxSize)}
            
        case .function(let function):
            valueCount = {point, size in function.inSize(size)(point)}
            
        case .gradient(let type, let stops, let data):
            let grayMap =  map.image(size: size).grayMap 
            valueCount = {point, size in grayMap.value(at: point, for: dotSize.maxSize)}
        }
        
        return {point, size in
            dotSize * (1-valueCount(point, size) )
        }
    }
    
    func detailSizeClosure(in  size: CGSize) 
    -> (CGPoint, CGSize) -> Double {
        mapValue(map: detailMap, dotSize: detailSize, in: size)
    }
    
    func dotSizeClosure(in size: CGSize) 
    -> (CGPoint, CGSize) -> Double {
        mapValue(map: sizeMap, dotSize: dotSize, in: size)
    }
    
    func rotationClosure(in size: CGSize)
    -> (CGPoint, CGSize) -> Double {
        mapValue(map: rotationMap, dotSize: rotationLimits, in: size)
    }
    
    func updateSizes() {
        switch sizeOwner {
        case .manager:
            _ = self.finalSize
        case .detailMap:
            if case .image(let source, _) = detailMap {
                self.finalSize = source.image.extent.size
            } else {
                sizeOwner = .manager
            }
        case .sizeMap:
            if case .image(let source, _) = sizeMap {
                self.finalSize = source.image.extent.size
            } else {
                //newSize = self.size
                sizeOwner = .manager
            }
        }
    }
}
