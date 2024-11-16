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
    enum SizeOwner {
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
    
    func mapValue(map: MapType, dotSize: DotSize, in size: CGSize) -> (CGPoint, CGSize) -> Double {
        let valueCount : (CGPoint, CGSize) ->Double
        let map = map.faltten(to: size)
        switch map {
            
        case .image(image: let image, _):
            let grayMap = image.grayMap            
            valueCount =  {point, _ in grayMap.value(at: point, for: dotSize.maxSize)}
        case .function(let function):
            valueCount = {point, size in function.inSize(size)(point)}
        case .number(value: let value):
            valueCount = {_, _ in value * dotSize.maxSize}
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
            if case .image(let image, _) = detailMap {
                self.finalSize = image.extent.size
            } else {
                //_self.size = self.size
                sizeOwner = .manager
            }
        case .sizeMap:
            if case .image(let image, _) = sizeMap {
                self.finalSize = image.extent.size
            } else {
                //newSize = self.size
                sizeOwner = .manager
            }
        }
    }
}
