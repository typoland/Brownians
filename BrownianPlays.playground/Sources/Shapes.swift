//
//  ZoneShape.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//
import SwiftUI

public struct ZoneShape: Shape {
    let angles: DotZoneAngles
    let size: Double
    public func path(in rect: CGRect) -> Path {
        Path {path in 
            path.move(to: angles.from)
            
            path.addArc(center: angles.from, 
                        radius: size, 
                        startAngle: .radians(angles.in), 
                        endAngle: .radians(angles.out), 
                        clockwise: false)
        
        }
    }
    
}

public struct LineAngleShape : Shape {
    var angle: Double
    var at: CGPoint
    var size: Double = 100.0
    public func path(in rect: CGRect) -> Path { 
        Path { path in
            let x = cos(angle) * size
            let y = sin(angle) * size
            path.move(to: at)
            path.addLine(to: CGPoint(x:at.x+x, y:at.y+y))
        }
    }
}

public struct LineSegmentShape : Shape {
    var segment: LineSegment
    public func path(in rect: CGRect) -> Path { 
        Path { path in
            path.move(to: segment.p0)
            path.addLine(to: segment.p1)
        }
    }
}

public struct DotDonut : Shape {
    var dot: Dot 
    public func path(in rect: CGRect) -> Path {
        Path { path in
            let s1 = dot.lowerBound
            let s2 = dot.upperBound
            let prop = (s1/2)/s2
            path.addEllipse(in: rect) 
           
            let inside = Path {p in
                let size = CGSize(width: rect.width*prop, height: rect.height*prop)
                let offset = (rect.size.width - rect.size.width * prop)/2
                let origin = CGPoint(x: offset, y: offset)
                p.addEllipse(in: NSRect(origin: origin, size: size))
            }
            path = path.symmetricDifference(inside, eoFill: true)

        }
    }
}


public struct DotShape : Shape {
    var frameSize: CGSize
    var at: CGPoint
    var size: CGFloat
    public func path(in rect: CGRect) -> Path {
        Path {path in
            path.move(to: CGPoint())
            let offset = at - CGPoint(x: frameSize.width/2, y: frameSize.height/2)
            let angle = atan2(offset.y, offset.x).normalizedAngle
            path.addArc(center: CGPoint(), 
                        radius: size*2, 
                        startAngle: Angle(radians: angle - 10.0.radians), 
                        endAngle: Angle(radians: angle + 10.0.radians),
                        clockwise: false)
            path.closeSubpath()
        }
    }
}

public struct CircleShape : Shape {
 
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
