//
//  CIImageExtensions.swift
//  
//
//  Created by Łukasz Dziedzic on 10/11/2024.
//
import CoreImage
import Accelerate
import AppKit

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
    
    func detailMap(radius: Double) -> CIImage? {
        self.morfologyGradient(radius: radius)?
            .gaussianBlur(radius: 4.0)?
            //.morfologyGradient(radius: radius)?
            .colorMonochrome(color: NSColor.white, 
                             intensity: 2)?
            .colorClamp(
                min: NSColor(red:0.0, green:0.0, blue:0.0, alpha: 0.0), 
                max: NSColor(red:1.0, green:1.0, blue:1.0, alpha: 1.0))
        
    }
}
@MainActor
public struct FiltersChain {
    enum Errors: Error {
        case filterFailed
    }
    let chain: [(CIImage) -> CIImage?]
    
    public init(chain: [(CIImage) -> CIImage?]) {
        self.chain = chain
    }
    public func result(source: CIImage) throws -> CIImage {
        var result: CIImage? = source
        for filter in chain {
            result = filter(result!)
            if result == nil {
                throw Errors.filterFailed
            }
        }
        return result!
    }
}

