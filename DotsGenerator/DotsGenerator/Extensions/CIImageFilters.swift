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
    
    func colorInvert() -> CIImage? {
        CIFilter(name:"CIColorInvert",
                 parameters: [
                    kCIInputImageKey: self
                    ]
        )?.outputImage
    }
    
    func documentEnchancer(amount: Double) -> CIImage? {
        CIFilter(name:"CIDocumentEnhancer",
                 parameters: [
                    kCIInputImageKey: self,
                    "inputAmount": NSNumber(value: amount)]
        )?.outputImage 
    }
    
}







