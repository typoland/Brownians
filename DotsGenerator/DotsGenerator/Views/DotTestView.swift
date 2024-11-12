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

struct DotTestView: View {

    @ObservedObject var manager: Manager

    public init(manager: Manager){
        self.manager = manager
    }
    
    
    public var body: some View {
        GeometryReader {proxy in
            Canvas {context, size in
            
                for dotIndex in 0..<manager.dots.count {
                    let dot = manager.dots[dotIndex]
                    let circleSize = dot.upperBound * dot.strength
                    let path = CircleShape().path(in: CGRect(x: dot.at.x, 
                                                             y: dot.at.y, 
                                                             width: circleSize, 
                                                             height: circleSize))
                    context.fill(path, with: .color(.black))
//                    for neigbour in dot.neighbors {
//                        let p = {Path { path in
//                            
//                            path.move(to: dot.at)
//                            path.addLine(to: neigbour)
//                            
//                        }}()
//                        let lineWidth = dot.strength * 7 + 0.2
//                        context.stroke(p, with: .color(.black), 
//                                       style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
//                    }
                    //dot.view(color: someColor(index: dotIndex), onlyDot: true)
                    
                        //.position(draggedDotPosition ?? dot.at)
                        //.gesture(dragDot(dot))
                }
                //            Circle().fill(Color.red)
                //                .frame(width:10, height:10)
                //                .position(cursor)

            }.background(content: {Color.white})
        }
    }
}


