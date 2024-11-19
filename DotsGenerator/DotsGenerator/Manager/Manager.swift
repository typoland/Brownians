//
//  Manager.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import Foundation
import CoreImage
import Combine

@MainActor
class Manager: ObservableObject, @preconcurrency Codable {
    
    enum SizeOwner : String, Codable {
        case manager
        case detailMap
        case sizeMap
    }
    
    var sizeOwner: SizeOwner = .manager
    var finalSize: CGSize = CGSize(width: 800, height: 600)
    var detailMap: MapType = Defaults.defaultMapImage
    var sizeMap: MapType = Defaults.defaultMapImage
    var detailSize = DotSize(minSize: 4, maxSize: 6)
    var dotSize = DotSize(minSize: 0.2, maxSize: 0.7)
    var dots: [Dot] = []
    var chaos: Double = 0.7
    var resultsFolderPath: URL? = nil
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sizeOwner = try container.decode(SizeOwner.self, forKey: .sizeOwner)
        self.finalSize = try container.decode(CGSize.self, forKey: .finalSize)
        self.detailMap = try container.decode(MapType.self, forKey: .detailMap)
        self.sizeMap = try container.decode(MapType.self, forKey: .sizeMap)
        self.detailSize = try container.decode(DotSize.self, forKey: .detailSize)
        self.dotSize = try container.decode(DotSize.self, forKey: .dotSize)
        self.chaos = try container.decode(Double.self, forKey: .chaos)
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
