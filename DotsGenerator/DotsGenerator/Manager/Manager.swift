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
import UniformTypeIdentifiers

@MainActor
class Manager: FileDocument, ObservableObject, @preconcurrency Codable {
    
    enum SizeOwner : String, Codable {
        case manager
        case detailMap
        case sizeMap
        case rotationMap
    }
    static var readableContentTypes: [UTType] { [.dotdot] }
    
    @Published var sizeOwner: SizeOwner = .manager
    @Published var finalSize: CGSize = CGSize(width: 800, height: 600)
    @Published var finalScale: Double = 1.0
    @Published var detailMap: MapType = Defaults.defaultMapImage
    @Published var sizeMap: MapType = Defaults.defaultMapImage
    @Published var detailSize = DotSize(minSize: 4, maxSize: 6)
    @Published var dotSize = DotSize(minSize: 0.2, maxSize: 0.7)
    @Published var dots: [Dot] = []
    @Published var chaos: Double = 0.7
    ///@Published var resultsFolderPath: URL? = nil
    
    @Published var rotationMap: MapType = Defaults.defaultMapRotation
    @Published var rotationLimits = DotSize(minSize: 0, maxSize: Double.tau)
    @Published var dotShape: DotShapeType = .rectangle(size: CGSize(width: 2, height: 0.5))
    
    required init(configuration: ReadConfiguration) throws {
        let decoder = JSONDecoder()
        guard let data = configuration.file.regularFileContents,
              let newSelf = try? decoder.decode(Manager.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        update(from: newSelf)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return .init(regularFileWithContents: data)
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sizeOwner = try container.decode(SizeOwner.self, forKey: .sizeOwner)
        self.finalSize = try container.decode(CGSize.self, forKey: .finalSize)
        self.finalScale = try container.decode(CGFloat.self, forKey: .finalScale)
        self.detailMap = try container.decode(MapType.self, forKey: .detailMap)
        self.sizeMap = try container.decode(MapType.self, forKey: .sizeMap)
        self.detailSize = try container.decode(DotSize.self, forKey: .detailSize)
        self.dotSize = try container.decode(DotSize.self, forKey: .dotSize)
        self.chaos = try container.decode(Double.self, forKey: .chaos)
        
        self.rotationMap = try container.decode(MapType.self, forKey: .rotationMap)
        self.rotationLimits = try container.decode(DotSize.self, forKey: .rotationLimits)
        self.dotShape = try container.decode(DotShapeType.self, forKey: .dotShape)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sizeOwner, forKey: .sizeOwner)
        try container.encode(finalSize, forKey: .finalSize)
        try container.encode(finalScale, forKey: .finalScale)
        try container.encode(detailMap, forKey: .detailMap)
        try container.encode(sizeMap, forKey: .sizeMap)
        try container.encode(detailSize, forKey: .detailSize)
        try container.encode(dotSize, forKey: .dotSize)
        try container.encode(chaos, forKey: .chaos)
        
        try container.encode(rotationLimits, forKey: .rotationLimits)
        try container.encode(rotationMap, forKey: .rotationMap)
        try container.encode(dotShape, forKey: .dotShape)
    }
    
    enum CodingKeys: CodingKey {
        case sizeOwner
        case finalSize
        case finalScale
        case detailMap
        case sizeMap
        case detailSize
        case dotSize
        case dots
        case chaos
        
        case rotationMap
        case rotationLimits
        
        case dotShape
            
    }
    
    func update(from manager: Manager) {
        sizeOwner = manager.sizeOwner
        finalSize = manager.finalSize
        finalScale = manager.finalScale
        detailMap = manager.detailMap
        sizeMap = manager.sizeMap
        detailSize = manager.detailSize
        dotSize = manager.dotSize
        rotationMap = manager.rotationMap
        rotationLimits = manager.rotationLimits
        dotShape = manager.dotShape
        dots = []
        chaos = manager.chaos
    }
    
    nonisolated init () {}
     
    private func mapValue(map: MapType, 
                          dotSize: DotSize, 
                          in size: CGSize) 
    -> (CGPoint, CGSize) -> Double 
    {
        let valueCount : (CGPoint, CGSize) ->Double
        let map = map.faltten(to: size)
        let size = CGSize(width: dotSize.maxSize, height: dotSize.maxSize)
       
        
        switch map {
            
            /*
             case .image(image: let source, _):
             let grayMap = source.image//.grayMap          
             valueCount =  {point, _ in grayMap
             .averageGray(at: point, in: size)}
             
             */
        case .image(image: let source, _):
            let grayMap = source.image.grayMap          
            valueCount =  {point, _ in grayMap.value(at: point, for: dotSize.maxSize)}
            
        case .function(let function):
            valueCount = {point, size in function.inSize(size)(point)}
            
        case .gradient:
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
            finalScale = 1
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
        case .rotationMap:
            if case .image(let source, _) = rotationMap {
                self.finalSize = source.image.extent.size
            } else {
                sizeOwner = .manager
            }
        }
    }
}
