//
//  CIImage.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import CoreImage
import AppKit
import Foundation
import Accelerate

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
    
        var cgImageTake : CGImage? {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(self, from: self.extent) {
                return cgImage
            }
            return nil
        }
    
    var nsImage : NSImage {
        let rep = NSCIImageRep(ciImage: self)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage 
    }
    
    var bufferWTF: SIMD4<UInt8> {
        var buffer = SIMD4<UInt8>.init(x: 0, y: 0, z: 0, w: 0)
        let context = CIContext()
        context.render(self, 
                       toBitmap: &buffer, 
                       rowBytes:  4, 
                       bounds: self.extent, 
                       format: .RGBA8,
                       colorSpace: nil)
        return buffer
    }
    
    var grayMap: [[Double]] {
        
        func simdToDouble(simd: SIMD4<UInt8>) -> Double {
            0.299 * Double(simd.x)/255 
            + 0.587 * Double(simd.y)/255  
            + 0.114 * Double(simd.z)/255 
        }
        let width = Int(self.extent.width)
        let height = Int(self.extent.height)
        let bufferSize = width*height
        let zero = SIMD4<UInt8>.init(x: 0, y: 0, z: 0, w: 0)
        var buffer : [SIMD4<UInt8>] = Array(repeating: zero, count: bufferSize)
        let context = CIContext()
        context.render(self, 
                       toBitmap: &buffer, 
                       rowBytes:  width*4, 
                       bounds: self.extent, 
                       format: .RGBA8,
                       colorSpace: nil)
        var result : [[Double]] = []
        (0..<height).forEach {rowIndex in
            let rowStart = rowIndex * width
            let rowEnd = rowStart + width
            let row = buffer[rowStart..<rowEnd]
            let grays = row.map {simdToDouble(simd: $0)}
            result.append(grays)
        }
        return result
    }
    
    func averageGray(at point:CGPoint, in size: CGSize) -> Double {
        guard let pixel = self.areaAverage(at: point, size: size)
        else {
            return 0
        }
       
        let context = CIContext(options: nil)
        let cg = context.createCGImage(pixel, from: pixel.extent)
        guard let dataProvider = cg?.dataProvider else {return 0} 
        var array: Array<UInt8> = Array(repeating: 0, count: 4)
        let range = CFRange(location: 0, length: 4)
        CFDataGetBytes(dataProvider.data, 
                               range, 
                               &array)
        let colors = array.map {CGFloat($0) / 255}
        let c = NSColor(red: colors[0], 
                green: colors[1], 
                blue: colors[2], 
                alpha: colors[3])
            .usingColorSpace(.genericGray)?.whiteComponent ?? 0
        return c
    }
    
    func pixelColor(at point: CGPoint) -> NSColor {
        let rect = CGRect(x: point.x.rounded(), y: point.y.rounded(),width: 1, height: 1)
        let pixelImage = self.cropped(to: rect)
        guard let cgImage =  CGImage.from(ciImage: pixelImage) //pixelImage.cgImageTake
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
}


extension Array where 
Element : Collection, 
Element.Element == Double,
Element.Index == Int {
    func value(at point: CGPoint, for size: Double) -> Double {
        let x = Int(point.x)// - size/2)
        let y = Int(point.y)// - size/2)
        
        guard !self.isEmpty, !self[0].isEmpty, y<count, x < self[0].count else {return 0}
        return self[y][x]
    }
}
