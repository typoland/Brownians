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
        let shift = NSRect(x: rect.origin.x-rect.width/2,
                           y: rect.origin.y-rect.height/2, 
                           width: rect.width*type.size.width,
                           height:rect.height*type.size.height)
        return Path { path in 
            type.addShape(path: &path, in: shift)
            let u = path.transform(rotationTransform)
            path = u.path(in: shift)
        }
    }
}

