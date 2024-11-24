//
//  CircleShape.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

struct CircleShape : Shape {
    var dot: Dot
    public func path(in rect: CGRect) -> Path {
        Path {path in
            let shift = NSRect(x: rect.origin.x-rect.width/2,
                               y: rect.origin.y-rect.height/2, 
                               width: rect.width*2,
                               height:rect.height/5)
            //path.addEllipse(in: shift)
            path.addRect(shift)//(in: shift)
//            var transform: CGAffineTransform  = CGAffineTransformMakeTranslation(dot.at.x, dot.at.y)
//            transform = CGAffineTransformRotate(transform, dot.rotation);
//            transform = CGAffineTransformTranslate(transform,-dot.at.x,-dot.at.y);
            let transform = CGAffineTransform(translationX: dot.at.x, y: dot.at.y)
                .rotated(by: dot.rotation)//* .pi / 180)
                .translatedBy(x: -dot.at.x, y: -dot.at.y)
            let u = path.transform(transform)// rotation(Angle(degrees: rotation))
            path = u.path(in: shift)
        }
    }
}
