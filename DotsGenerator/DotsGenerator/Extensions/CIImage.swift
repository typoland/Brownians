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
}


extension Array where 
Element : Collection, 
Element.Element == Double,
Element.Index == Int {
    func value(at point: CGPoint, for size: Double) -> Double {
        let x = Int(point.x)// - size/2)
        let y = Int(point.y)// - size/2)
        
        guard !self.isEmpty, !self[0].isEmpty, y<count, x < self[0].count else {return Double.nan}
        return self[y][x]
        //Somehow take average from [y...y+width][x...x+width
        /*
        let blockSize = Int(size)
        let ox = x < 0 ? 0 : x
        let oy = y < 0 ? 0 : y
        
        let oHeight = oy + blockSize >= self.count ? self.count - oy : blockSize
        let oWidth = ox + blockSize >= self[0].count ? self[0].count - ox : blockSize
        
        print (ox, oy, oHeight, oWidth)
        var counter = 0.0
        var sum = 0.0
//        print (oy..<oy+oHeight)
        let cut = self[oy..<oy+oHeight]
        for line in cut {
            for val in line[ox..<ox+oWidth] {
                sum += val
                counter += 1
            }
        }
        print (sum/counter)
//        print ()
        return sum/counter
         */
    }
}
