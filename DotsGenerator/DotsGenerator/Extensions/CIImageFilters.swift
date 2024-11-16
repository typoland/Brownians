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
        )?.outputImage?.cropped(to: self.extent) 
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
    
    func scaleTo (newSize: CGSize) -> CIImage {
        
        let scaleX = newSize.width/self.extent.size.width
        let scaleY = newSize.height/self.extent.size.height
        return self.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY)) 
        
    }
    
    func resize(scale: Double, ratio: Double) -> CIImage? {
        CIFilter(name:"CILanczosScaleTransform",
                 parameters: [
                    kCIInputImageKey: self,
                    kCIInputScaleKey: NSNumber(value: scale),
                    kCIInputAspectRatioKey: NSNumber(value: scale),
                 ]
        )?.outputImage 
    }
    
    func areaAverage(at point: CGPoint) -> CIImage? {
        let rect = CGRect(origin: CGPoint(x: point.x-1, 
                                          y: point.y-1), 
                          size: CGSize(width: 3, height: 3))
        return CIFilter(name:"CIAreaAverage",
                 parameters: [
                    kCIInputImageKey: self,
                    kCIInputExtentKey: rect,
                 ]
        )?.outputImage 
    }
}







