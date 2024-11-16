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

    //@ObservedObject var manager: Manager
    var dots: [Dot]
    var size: CGSize 
//    public init(manager: Manager){
//        self.manager = manager
//    }
//    
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
                }
            }
        }.background(content: {Color.white})
    }
    public var body: some View {
        ZStack {
            //GeometryReader {proxy in
            canvas
            Button (action: {
                savePDF(name: "new")
            }) {
                Text("save PDF in dot View")
            }
        }
      //  }
    }
}

