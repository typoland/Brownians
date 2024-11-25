//
//  DotTestView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//


//
//  DotTestView.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//


import SwiftUI
import Foundation

struct DotView: View {

    @EnvironmentObject var manager: Manager
    var dots: [Dot]
    var size: CGSize 
    @Binding var savePDF: Bool

    var canvas : some View {
        Canvas {context, size in                    
            for dotIndex in 0..<dots.count {
                let dot = dots[dotIndex]
                let circleSize = dot.upperBound * dot.dotSize
                if circleSize > 0 {
                    let path =  DotShape(dot: dot, type: manager.dotShape)
                    
                        .path(in: CGRect(x: dot.at.x, 
                                         y: dot.at.y, 
                                         width: circleSize, 
                                         height: circleSize))
                    
                    context.fill(path, with: .color(.black))
                    
                    //*
//                    context.fill(path, with: .color(dotIndex > 1 ? Color.tryIndex(dotIndex) : dotIndex == 0 ? .red : .green))
                     //*/
                }
            }
            /*
            for dotIndex in dots.indices {
                var path = Path()
                let rect = NSRect(origin: dots[dotIndex].at, size: CGSize(width: 5, height: 5))
                path.addEllipse(in: rect.onCenter)
                context.fill(path, with: .color(Color.tryIndex(dotIndex)))
                
                path = Path()
                let r2 = NSRect(origin: dots[dotIndex].at, size: CGSize(width: 12, height: 12))
                path.addEllipse(in: r2.onCenter)
                context.stroke(path, with: .color(.gray), lineWidth: 1)
            }
             */
        }
    }
    
    public var body: some View {
        ZStack {
            canvas
        }.onChange(of: savePDF) { 
            if savePDF {
                if let url = manager.resultsFolderPath {
                    savePDF(url: url, name: "dots")
                    savePDF = false
                }
            }
        }
      //  }
    }
}

