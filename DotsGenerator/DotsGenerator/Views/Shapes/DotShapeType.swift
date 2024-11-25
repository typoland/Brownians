//
//  DotShapeType.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 25/11/2024.
//
import Foundation
import SwiftUI

enum DotShapeType: Codable, Hashable {
    
    enum Errors: Error {
        case noIndex(Int)
    }
    
    case oval(size: CGSize)
    case rectangle(size: CGSize)
    
    func addShape(path: inout Path, in rect: CGRect) {
        switch self {
        case .rectangle:
            path.addRect(rect)
        case .oval:
            path.addEllipse(in:rect)
        }
    } 
    
    var size: CGSize {
        switch self {
        case .oval(let size): return size
        case .rectangle(let size): return size
        }
    }
    
    var index: Int {
        switch self {
        case .oval: return 0
        case .rectangle: return 1
        }
    }
    init(index: Int) throws {
        switch index {
        case 0: self = .oval(size: CGSize(width: 1, height: 1))
        case 1:  self = .rectangle(size: CGSize(width: 1, height: 1))
        default: throw Errors.noIndex(index)   
        }
    }
}
