//
//  DotShape.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 25/11/2024.
//
import Foundation
import SwiftUI


struct DotShape: Shape {
    
    
    var dot: Dot
    var type: DotShapeType
    
    var rotationTransform : CGAffineTransform {
        CGAffineTransform(translationX: dot.at.x, y: dot.at.y)
            .rotated(by: dot.rotation)//* .pi / 180)
            .translatedBy(x: -dot.at.x, y: -dot.at.y)
    }
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in 
            type.addShape(path: &path, in: rect)
            let u = path.transform(rotationTransform)
            path = u.path(in: rect)
        }
    }
}

