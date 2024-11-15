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
    
    @Published var size: CGSize = CGSize(width: 1024, height: 1024)
    
    @Published var detailMap: MapType = Defaults.defaultMapImage
    
    @Published var sizeMap: MapType = Defaults.defaultMapImage
    
    @Published var detailSize = DotSize(minSize: 4, maxSize: 6)
    @Published var dotSize = DotSize(minSize: 0.2, maxSize: 0.7)
    
    @Published var dots: [Dot] = []
    
    @Published var chaos: Double = 0.7
    
    func mapValue(map: MapType, dotSize: DotSize) -> (CGPoint, CGSize) -> Double {
        return {point, size in
            dotSize * map.value(at: point, in: size) 
        }
    }
    
    func det() -> (CGPoint, CGSize) -> Double {
        mapValue(map: detailMap, dotSize: detailSize)
    }
    func siz() -> (CGPoint, CGSize) -> Double {
        mapValue(map: sizeMap, dotSize: dotSize)
    }
//    func mapValue(at point: CGPoint, 
//                  in map: MapType
//                  ) -> Double {
//        
//        return (map.value(at: point, in: size)) 
//    }
    
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
//        let dotSize = self.dotSize
//        let detailSize = self.detailSize
        let generator = DotGenerator()
        Task {
            await generator
                .makeDotsTask(in:  size, 
                          //result: &dots,
                          detailMap: det(), 
                          dotSizeMap: siz(), 
                          chaos: chaos)
        }
    }
    
   
    
}
