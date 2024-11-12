//
//  CircleShape.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

struct CircleShape : Shape {
    
    public func path(in rect: CGRect) -> Path {
        Path {path in
            let shift = NSRect(x: rect.origin.x-rect.width/2,
                               y: rect.origin.y-rect.height/2, 
                               width: rect.width,
                               height:rect.height)
            path.addEllipse(in: shift)
        }
    }
}
