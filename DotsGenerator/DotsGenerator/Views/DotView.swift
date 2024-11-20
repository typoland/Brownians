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
                    let path = CircleShape()
                        .path(in: CGRect(x: dot.at.x, 
                                         y: dot.at.y, 
                                         width: circleSize, 
                                         height: circleSize))
                    context.fill(path, with: .color(.black))
                    /*
                    context.fill(path, with: .color(dotIndex > 1 ? Color.tryIndex(dotIndex) : dotIndex == 0 ? .red : .green))
                     */
                }
            }
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

