//
//  CIImage.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import CoreImage
import AppKit

public extension CGImage {
    static func from(ciImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil 
    }
}
public extension NSColor {
    var grayValue: Double {
        let r = self.redComponent
        let g = self.greenComponent
        let b = self.blueComponent
        return 0.299*r + 0.587*g + 0.114*b
    }
}
import Accelerate

public extension CIImage {
    //    var cgImage : CGImage? {
    //        let context = CIContext(options: nil)
    //        if let cgImage = context.createCGImage(self, from: self.extent) {
    //            return cgImage
    //        }
    //        return nil
    //    }
    var nsImage : NSImage {
        let rep = NSCIImageRep(ciImage: self)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage 
    }
    
    var detailMap: CIImage? {
        guard let edges = CIFilter(name: "CICannyEdgeDetector",
                                   parameters: [kCIInputImageKey: self,
                                                //"inputGaussianSigma": NSNumber(0)
                                               ]
        )?.outputImage else {return nil}
        guard let blurred = CIFilter(name:"CIGaussianBlur",
                                     parameters: [kCIInputImageKey: edges,
                                                  "inputRadius": NSNumber(4)])?.outputImage else {return nil}
        guard let adjusted = CIFilter(name:"CIExposureAdjust",
                                      parameters: [kCIInputImageKey: blurred,
                                                   "inputEV": NSNumber(1.5)
                                                  ])?.outputImage else {return nil}
        return adjusted 
        
        
    }
    
    func pixelColor(at point: CGPoint) -> NSColor {
        let rect = CGRect(x: point.x.rounded(), y: point.y.rounded(),width: 1, height: 1)
        let pixelImage = self.cropped(to: rect)
        guard let cgImage = CGImage.from(ciImage: pixelImage)
        else { 
            print ("no cgImage")
            return NSColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        guard var format = vImage_CGImageFormat(cgImage: cgImage) else {
            NSLog("Unable to derive format from image.")
            return NSColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        guard let buf = try? vImage.PixelBuffer(
            cgImage: cgImage,
            cgImageFormat: &format,
            pixelFormat: vImage.Interleaved8x4.self)
                
        else {
            print ("no buffer")
            return NSColor(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if buf.count == 1 {
            let c = Double(buf.array[0])/255.0
            return NSColor(red: 0.299*c, green: 0.587*c, blue: 0.114*c, alpha: 1)
        }
        let r = Double(buf.array[0])/255.0
        let g = Double(buf.array[1])/255.0
        let b = Double(buf.array[2])/255.0
        let a = Double(buf.array[3])/255.0
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    
    var detailLevel: Double {
        let filterEdgeDetector = CIFilter(name: "CICannyEdgeDetector",
                                          parameters: [kCIInputImageKey: self,
                                                       //"inputGaussianSigma": NSNumber(0)
                                                      ]
        ) 
        guard let definedEdges = filterEdgeDetector?.outputImage 
        else {print ("no edges")
            return 0.0
        }
        
        guard let cgImage = CGImage.from(ciImage: definedEdges)
        else { 
            print ("no cgImage \(definedEdges.extent)")
            return 0.0
        }
        guard var format = vImage_CGImageFormat(cgImage: cgImage) else {
            NSLog("Unable to derive format from image.")
            return 0.0
        }
        
        guard let buf = try? vImage.PixelBuffer(
            cgImage: cgImage,
            cgImageFormat: &format,
            pixelFormat: vImage.Interleaved8x4.self)
                
        else {print ("no buffer")
            return 0.0}
        
        var sum = 0.0
        let componentLength = Double(format.bitsPerPixel) / Double(format.bitsPerComponent)
        
        for i in stride(from: 0, to: buf.array.count, by: Int(componentLength)) {
            sum += Double(buf.array[i])/255.0
        }
        return sum / (Double(buf.array.count) / componentLength)
    }
    
    var averageColor: NSColor {
        guard let cgImage = self.cgImage// CGImage.from(ciImage: self)
        else { 
            print ("no cgImage")
            return NSColor.clear
        }
        guard var format = vImage_CGImageFormat(cgImage: cgImage) else {
            NSLog("Unable to derive format from image.")
            return NSColor.clear
        }
        
        guard let buf = try? vImage.PixelBuffer(
            cgImage: cgImage,
            cgImageFormat: &format,
            pixelFormat: vImage.Interleaved8x4.self)
                
        else {
            print ("no buffer")
            return  NSColor.clear
        }
        
        var sum = [0.0, 0.0, 0.0]
        
        
        let componentLength = Double(format.bitsPerPixel) / Double(format.bitsPerComponent)
        
        for i in stride(from: 0, to: buf.array.count, by: Int(componentLength)) {
            sum[0] += Double(buf.array[i])/255.0
            sum[1] += Double(buf.array[i+1])/255.0
            sum[2] += Double(buf.array[i+2])/255.0
        } 
        let res = sum.map{$0/(Double(buf.array.count) / componentLength)}
        print (res)
        return NSColor(red: res[0], green: res[1], blue: res[2], alpha: 1)
    }
}
