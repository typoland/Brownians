//
//  DorView.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//


import SwiftUI

public extension Dot {
   
    @MainActor
    func view(color: Color = Color.yellow, full: Bool = true, label: Bool = true, onlyDot: Bool = false) -> some View {
        //GeometryReader {context in
            ZStack {
                let size = self.upperBound * 2
                if full && !onlyDot {
                    DotDonut(dot: self)
                        .fill(color).opacity(0.05)
                        .frame(width: size, height: size)
                    
                }
//                DotShape(frameSize: CGSize(width: 800, height: 800), 
//                         at: self.at, 
//                         size: self.upperBound)
//                .fill(.black)
//                    .frame(width: 8, height: 8)
                CircleShape()
                    .fill(Color.black)
                    .frame(width: lowerBound * 0.6, height: lowerBound * 0.6)
                    //.zIndex(999)
                if full && !onlyDot{
                    Circle()
                        .stroke(color, lineWidth: 0.3)
                        .fill(Color.clear)
                        .frame(width: self.lowerBound*0.5, height: self.lowerBound*0.5)
                    Circle()
                        .stroke(color, lineWidth: 0.8)
                        .fill(Color.clear).opacity(0.3)
                        .frame(width: size, height: size)
                    if label && self.upperBound > 100.0 {
                        Text("\(self.description)")
                            .font(.system(size: 9)).offset(y: -12)
                    }
                }
            }
      //  }
    }
}
