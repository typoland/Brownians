//
//  TwoDotAngles.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//
import Foundation
import SwiftUI


@MainActor
public struct TwoDotAngles {
    public var up: DotZoneAngles
    public var down: DotZoneAngles
    enum ZoneErrors: Error {
        case noCommon
    }
    
    public init(dot1:Dot, dot2: Dot) throws {
        
        let io = dot1.innerCircle * dot2.outerCircle
        let oi = dot1.outerCircle * dot2.innerCircle
        
        if case let .points( ioUp, ioDn) = io,
           case let .points( oiUp, oiDn) = oi {
            
            let xIoUp = ioUp.x - dot1.at.x
            let yIoUp = ioUp.y - dot1.at.y 
            let angleIoUp = atan2(yIoUp, xIoUp)
            
            let xOiUp = oiUp.x - dot1.at.x
            let yOiUp = oiUp.y - dot1.at.y 
            let angleOiUp = atan2(yOiUp, xOiUp)
            
            
            let xIoDn = ioDn.x - dot1.at.x
            let yIoDn = ioDn.y - dot1.at.y 
            let angleIoDn = atan2(yIoDn, xIoDn)
            
            let xOiDn = oiDn.x - dot1.at.x
            let yOiDn = oiDn.y - dot1.at.y 
            let angleOiDn = atan2(yOiDn, xOiDn)
            
            
            self.up = DotZoneAngles(in: angleIoUp, out:angleOiUp, from: dot1.at)
            self.down = DotZoneAngles(in: angleOiDn, out: angleIoDn, from: dot1.at)
        }
        else {
            throw ZoneErrors.noCommon
        }
    }
    
    
    
    public var view: some View {
        
        ZStack {
            let style = StrokeStyle(lineWidth: 0.5, lineCap: .round)
            up.view.fill(Color.red).opacity(0.3)
            down.view.fill(Color.blue).opacity(0.3)
            
            LineAngleShape(angle: up.in, at: up.from)
                .stroke(Color.red, style: style)//.position(up.from)
            LineAngleShape(angle: up.out, at: up.from)
                .stroke(Color.orange, style: style)//.position(up.from)
            LineAngleShape(angle: down.in, at: down.from)
                .stroke(Color.green, style: style)//.position(down.from)
            LineAngleShape(angle: down.out, at: down.from)
                .stroke(Color.blue, style: style)//.position(down.from)
            
            
            let style2 = StrokeStyle(lineWidth: 1, lineCap: .round, dash: [2,5])
            ForEach ((0...5).indices, id: \.self) { index in
                //ZStack {
                    LineAngleShape(angle: up.random, at: up.from, size: 90)
                        .stroke(Color.red, style: style2)
                    
                    LineAngleShape(angle: down.random, at: down.from, size: 90)
                        .stroke(Color.blue, style: style2)
                    
                    
              
               // }
            }
        }
    }
    
}
