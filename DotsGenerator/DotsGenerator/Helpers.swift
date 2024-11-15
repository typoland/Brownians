//
//  Helpers.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import AppKit
struct Defaults {
    static let filtersChain = FiltersChain(chain: [
        .morfologyGradient(radius: 8),
        .colorMonochrome(color: NSColor.white, 
                            intensity: 2),
        .colorClamp(
            min: NSColor(red:0.0, green:0.0, blue:0.0, alpha: 0.0), 
            max: NSColor(red:1.0, green:1.0, blue:1.0, alpha: 1.0)),
        
        .gaussianBlur(radius: 10.0)
        
    ])
    
    static var ciImage: CIImage {
        NSImage(named: "Love")!.ciImage!
    }
    
    static var defaultMapImage: MapType {
        MapType.image(image: Defaults.ciImage, filters: nil, dotSize: DotSize(minSize: 10, maxSize: 20))
    }
    static var defaultMapValue: MapType {
        MapType.number(value: 0.5)
    }
    static var defaultMapFunction: MapType {
        MapType.function(.horizontalBlend, 
                         dotSize: DotSize(minSize: 5, maxSize: 10))
    }
}
