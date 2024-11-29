//
//  DotShapeType.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 25/11/2024.
//
import Foundation
import SwiftUI

extension CGRect {
    var onCenter: CGRect {
        return CGRect(origin: CGPoint(x: origin.x-size.width/2, 
                                      y: origin.y-size.height/2), 
                      size: self.size)
    }
    
    static func * (lhs:Self, rhs:CGSize) -> Self {
        let newWidth = lhs.width * rhs.width
        let newHeight = lhs.height * rhs.height
        let size = CGSize(width: newWidth ,
                          height: newHeight)
        let x = lhs.origin.x - (newWidth - lhs.size.width)/2
        let y = lhs.origin.y - (newHeight - lhs.size.height)/2
        return CGRect(origin: CGPoint(x: x, y: y), 
                      size: size)
    }
}



enum DotShapeType: Codable, Hashable {
    
    enum Errors: Error {
        case noIndex(Int)
    }
    
    case oval(size: CGSize)
    case rectangle(size: CGSize)
    case triangle(size: CGSize)
    case diamond(size: CGSize)
    
    func addShape(path: inout Path, in rect: CGRect) {
        
        switch self {
        case .rectangle(let size):
            path.addRect(rect.onCenter * size)
        case .oval(let size):
            path.addEllipse(in: rect.onCenter * size)
        case .triangle(let size):
            let rect = rect.onCenter * size
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.origin.x + rect.size.width, 
                                     y: rect.origin.y + rect.size.height/2))
            path.addLine(to: CGPoint(x: rect.origin.x, 
                                     y: rect.origin.y + rect.size.height))
            path.closeSubpath()
        case .diamond(size: let size):
            let rect = rect.onCenter * size
            path .move(to: CGPoint(x: rect.origin.x, 
                                   y: rect.origin.y + rect.size.height/2))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width/2, 
                                     y: rect.origin.y + rect.size.height))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width, 
                                     y: rect.origin.y + rect.size.height/2))
            path.addLine(to: CGPoint(x: rect.origin.x + rect.width/2, 
                                     y: rect.origin.y))
            path.closeSubpath()
            
        }
    
    } 
        
    var index: Int {
        switch self {
        case .oval: return 0
        case .rectangle: return 1
        case .triangle: return 2
        case .diamond: return 3
        }
    }
    init(index: Int) throws {
        switch index {
        case 0: self = .oval(size: CGSize(width: 1, height: 1))
        case 1:  self = .rectangle(size: CGSize(width: 1, height: 1))
        case 2:  self = .triangle(size: CGSize(width: 1, height: 1))
        case 3:  self = .diamond(size: CGSize(width: 1, height: 1))
        default: throw Errors.noIndex(index)   
        }
    }
}
