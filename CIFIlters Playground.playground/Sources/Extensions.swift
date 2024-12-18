//
//  Extensions.swift
//  
//
//  Created by Łukasz Dziedzic on 09/11/2024.
//
import AppKit
import CoreImage
import Accelerate

//public extension NSImage {
//    /// Generates a CIImage for this NSImage.
//    /// - Returns: A CIImage optional.
//    func ciImage() -> CIImage? {
//        guard let data = self.tiffRepresentation,
//              let bitmap = NSBitmapImageRep(data: data) else {
//            return nil
//        }
//        let ci = CIImage(bitmapImageRep: bitmap)
//        return ci
//    }
//}

public extension CGImage {
    static func from(ciImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return cgImage
        }
        return nil 
    }
}

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
        guard let image1 = CIFilter.highlightShadowAdjust(
            image: self, 
            radius: 15, 
            shadowAmount: 1, 
            highlightAmount: 1)  else {return nil}
        
        guard let twice = CIFilter.highlightShadowAdjust(
            image: image1, 
            radius: 15, 
            shadowAmount: 1, 
            highlightAmount: 1) else {return nil}
        
//        guard let shadows = CIFilter(name: "CIHighlightShadowAdjust")?.outputImage 
//        else {return nil}
        guard let edges = CIFilter(name: "CICannyEdgeDetector",
                                          parameters: [kCIInputImageKey: twice,
                                                       //"inputGaussianSigma": NSNumber(0)
                                                      ]
        )?.outputImage else {return nil}
         
        print (blurred)
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
        print (buf.array.count, buf.array)
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
        guard let edges = filterEdgeDetector?.outputImage 
        else {print ("no edges")
            return 0.0
        }
        
        guard let cgImage = edges.cgImage //CGImage.from(ciImage: edges)
        else { 
            print ("no cgImage")
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
