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
    
    static var imageSource: ImageSource {
        .local(name: "Love")
        //NSImage(named: "Love")!.ciImage!
    }
    
    
    static var defaultMapImage: MapType {
        MapType.image(image: Defaults.imageSource, filters: FiltersChain(chain: []))
    }

    static var defaultMapFunction: MapType {
        MapType.function(.custom(CustomFunction()))
    }
    
    static var defaultMapValue: MapType {
        MapType.function(.custom(CustomFunction()))
    }
}

func debugPrint(_ s : String...) {
#if DEBUG
    print ("Debug:", s.reduce(into:"", {$0+=" \($1)"}))
#endif
}
