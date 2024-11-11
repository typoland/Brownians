//
//  CIImageExtensions.swift
//  
//
//  Created by Łukasz Dziedzic on 10/11/2024.
//
import AppKit
import CoreImage


public extension CIImage {
    
    func gaussianBlur(radius: Double) -> CIImage? {
        CIFilter(name:"CIGaussianBlur",
                 parameters: [
                    kCIInputImageKey: self,
                    "inputRadius": NSNumber(value: radius)]
        )?.outputImage 
    }
    
    func colorClamp(min: NSColor, max: NSColor) -> CIImage? {
        let vMin = CIVector(x: CGFloat(min.redComponent), 
                            y: CGFloat(min.greenComponent), 
                            z: CGFloat(min.blueComponent), 
                            w: CGFloat(min.alphaComponent))
        
        let vMax = CIVector(x: CGFloat(max.redComponent), 
                            y: CGFloat(max.greenComponent), 
                            z: CGFloat(max.blueComponent), 
                            w: CGFloat(max.alphaComponent))
        
        return CIFilter(name:"CIColorClamp",
                 parameters:[
                    kCIInputImageKey: self,
                    "inputMinComponents" : vMin,
                    "inputMaxComponents" : vMax
                 ]
        )?.outputImage
    }
    
    
    func morfologyGradient(radius: Double) -> CIImage? {
        CIFilter(name:"CIMorphologyGradient",
                 parameters: [
                    kCIInputImageKey: self,
                    "inputRadius": NSNumber(value: radius)]
        )?.outputImage 
    }
    
    
    func colorMonochrome(color: NSColor, intensity: Double) -> CIImage? {
        guard let ciColor = CIColor(color: color) else {return nil}
        return CIFilter(name:"CIColorMonochrome",
                        parameters: [
                            kCIInputImageKey: self,
                            "inputColor": ciColor,
                            "inputIntensity": NSNumber(value: intensity)]
        )?.outputImage 
        
    }
}





import SwiftUI

struct FilterView : View {
    @Binding var filter: Filters 
    var body: some View {
        
        VStack (alignment: .leading, spacing: 5) {
            switch filter {
            case .colorMonochrome(let color, let intensity):
                let bindingColor = Binding(get: {Color(nsColor: color)}, 
                                           set: {filter = .colorMonochrome(color: NSColor($0), intensity: intensity)}) 
                let bindingIntensity = Binding(get: {intensity}, 
                                               set: {filter = .colorMonochrome(color: color, intensity: $0)}) 
                Text("Color Monochrome").lineLimit(1).fontWeight(.black)
                TextField("intensity", value: bindingIntensity, format: .number)
                ColorPicker("color", selection: bindingColor, supportsOpacity: false)
                
            case .morfologyGradient(radius: let radius):
                let bindingRadius = Binding(get: {radius}, 
                                            set: {filter = .morfologyGradient(radius: $0)}) 
                Text("Morfology Gradient").lineLimit(1).fontWeight(.black)
                TextField("radius", value: bindingRadius, format: .number)
                
            case .colorClamp(min: let min, max: let max):
                let bindingMin = Binding(get: {Color(nsColor: min)}, 
                                         set: {filter = .colorClamp(min: NSColor($0), max: max)}) 
                let bindingMax = Binding(get: {Color(nsColor: max)}, 
                                         set: {filter = .colorClamp(min: min, max: NSColor($0))}) 
                Text("Color Clamp").lineLimit(1).fontWeight(.black)
                ColorPicker("min:", selection: bindingMin, supportsOpacity: false)
                ColorPicker("max:", selection: bindingMax, supportsOpacity: false)
                
            case .gaussianBlur(radius: let radius):
                let bindingRadius = Binding(get: {radius}, 
                                            set: {filter = .gaussianBlur(radius: $0)}) 
                Text("Gaussian Blur").lineLimit(1).fontWeight(.black)
                TextField("radius", value: bindingRadius, format: .number)
            }
        }
        
    }
}


