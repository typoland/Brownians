//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 06/11/2024.
//

import Foundation

public extension ClosedRange where Bound == Double {
    var degrees: String {
        "\(lowerBound.degrees)...\(upperBound.degrees)"
    }
}
public extension FloatingPoint {
    var degrees: String {
        "\(deg._0001)°"
    }
    var deg: Self {
        self.normalizedAngle/Self.pi * 180 
    }
    var radians: Self {
        self*Self.pi / 180
    }
    var _0001: Self {
        (self * Self(Int(100.0))).rounded(.towardZero)/Self(Int(100.0))
    }
    var normalizedAngle: Self {
        let a = self.truncatingRemainder(dividingBy: Self.tau) 
        return a < 0 ? a + Self.tau : a
    }
    var squared: Self {
        return self*self
    }
    static var tau: Self {
        Self.pi * 2
    }
    
    var closeIntoTau: Self {
        let a = self.truncatingRemainder(dividingBy: Self.tau) 
        return a < 0 ? a + Self.tau : a
    }
}
//func upOrDown (p1: CGPoint, p2: CGPoint, ext: CGPoint) -> Dot.ZoneSide {
//    let dotsOffset = p2 - p1
//    let middlePoint = (dotsOffset) * 0.5 + p1
//    let dotsAngle = atan2(dotsOffset.y, dotsOffset.x)
//    let toMiddle = ext - middlePoint
//    
//    let angleToMiddle = atan2(toMiddle.y,toMiddle.x)
//    return (angleToMiddle - dotsAngle).normalizedAngle < Double.pi ?
//        .down : .up
//}

infix operator .<>.
//gives normalized angle counterclockwise range in positive values
public func .<>. (lhs: Double, rhs: Double) -> [ClosedRange<Double>] {
    if abs(rhs - lhs).truncatingRemainder(dividingBy: Double.tau) < 0.001 {return [0...Double.tau]}
    //let clockwise = lhs > rhs
 
    
    let a1 = lhs.truncatingRemainder(dividingBy: Double.tau).closeIntoTau
    let a2 = rhs.truncatingRemainder(dividingBy: Double.tau).closeIntoTau

    
    //print ("a1", a1.degrees, "a2", a2.degrees)
    return a1 > a2 ? [0.0...a2, a1...Double.tau]
    : [a1...a2]
    
}

import SwiftUI
infix operator |-|

public extension CGPoint {
    static func - (lhs: Self, rhs: Self) -> Self {
        return CGPoint (x:lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    static func + (lhs: Self, rhs: Self) -> Self {
        return CGPoint (x:lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    static func * (lhs: Self, rhs: Double) -> Self {
        return CGPoint (x:lhs.x * rhs, y: lhs.y * rhs)
    }
    
    static func |-| (lhs: Self, rhs: Self) -> Double {
        let o = rhs - lhs
        return sqrt(o.x.squared + o.y.squared)
    }
    func offset(angle: Double, distance: Double) -> CGPoint {
        return CGPoint(x: cos(angle) * distance + self.x,
                       y: sin(angle) * distance + self.y)
    }
    func onSide(of p1: CGPoint, and p2: CGPoint) -> Dot.ZoneSide {
        let dotsOffset = p2 - p1
        let middlePoint = (dotsOffset) * 0.5 + p1
        let dotsAngle = atan2(dotsOffset.y, dotsOffset.x)
        let toMiddle = self - middlePoint
        
        let angleToMiddle = atan2(toMiddle.y,toMiddle.x)
        return (angleToMiddle - dotsAngle).normalizedAngle < Double.pi ?
            .down : .up
    }
}

public extension CGPoint {
    var view: some View {
        Circle().fill(Color.yellow)
            .frame(width:18, height:18)
        
    }
}

public extension CGSize {
    func contains(_ point:CGPoint) -> Bool {
        (0...width).contains(point.x)
        && (0...height).contains(point.y)
    }
}


public func someColor(index: Int) -> Color {
    if index == 0 {return .red}
    return .gray
//    return Color(red: Double.random(in: 0.1...0.8), 
//                 green: Double.random(in: 0.1...0.9), 
//                 blue: Double.random(in: 0.1...0.9))
    //return colors[Int.random(in: 0...index % colors.count)]
    //    return index >= colors.count
    //    ? Color(red: Double.random(in: 0.2...0.9),
    //            green: Double.random(in: 0.2...0.9),
    //            blue: Double.random(in: 0.2...0.9))
    //    : colors[index]
}

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
public extension NSColor {
    var grayValue: Double {
        let r = self.redComponent
        let g = self.greenComponent
        let b = self.blueComponent
        return 0.299*r + 0.587*g + 0.114*b
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
