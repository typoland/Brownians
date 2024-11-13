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
    
    struct DotSize {
        var maxSize: Double
        var minSize: Double
        static func * (lhs: Self, rhs: Double) -> Double {
            (lhs.maxSize-lhs.minSize) * rhs + lhs.minSize //lerp
            //(rhs + lhs.minSize) * lhs.maxSize + lhs.minSize
        }
    }
    
    @Published var sizeOwner: SizeOwner = .manager
    
    @Published var size: CGSize = CGSize(width: 1024, height: 1024)
    
    @Published var detailMap: MapType = Defaults.defaultMapImage
    
    
    @Published var sizeMap: MapType = Defaults.defaultMapImage
    
    @Published var detailSize = DotSize(maxSize: 6, minSize: 4)
    @Published var dotSize = DotSize(maxSize: 0.7, minSize: 0.2)
    
    @Published var dots: [Dot] = []
    
    @Published var chaos: Double = 0.7
    
    func mapValue(at point: CGPoint, in map: MapType, for sizes: DotSize) -> Double {
        let gray = 1.0 - ((try? map.value(at: point)) ?? 0.5)
        return sizes * gray
    }
    
    func updateSizes() {
        

        
        switch sizeOwner {
        case .manager:
            _ = self.size
        case .detailMap:
            if case .image(let image, _) = detailMap {
                self.size = image.extent.size
            } else {
                //_self.size = self.size
                sizeOwner = .manager
            }
        case .sizeMap:
            if case .image(let image, _) = sizeMap {
                self.size = image.extent.size
            } else {
                //newSize = self.size
                sizeOwner = .manager
            }
        }
        //Scale others
    }
    
    
    func updateDots(in size: CGSize) async {
        dots = []
       print ("Update Dots!")
        let detailMap = detailMap.faltten(to: size)
        let sizeMap = sizeMap.faltten(to: size)
        let dotSize = self.dotSize
        let detailSize = self.detailSize
        Task {
             DotGenerator
                .makeDots(in:  size, 
                          result: &dots,
                          detailSize: {self.mapValue(at: $0, 
                                                     in: detailMap,
                                                     for: detailSize)}, 
                          dotSize: {self.mapValue(at: $0, 
                                                  in: sizeMap,
                                                  for: dotSize)}, 
                          chaos: chaos)
        }
    }
    
   
    
}
