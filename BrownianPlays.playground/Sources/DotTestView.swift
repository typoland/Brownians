//
//  DotTestView.swift
//  
//
//  Created by Łukasz Dziedzic on 07/11/2024.
//


import SwiftUI
import Foundation

public struct DotTestView: View {
    @State var cursor: CGPoint = CGPoint(x:400, y: 400)
    @State var isDragging: Bool = false
    var dots: [Dot] = []
    @State var draggedDotPosition : CGPoint? = nil
    
    func makeDots(in size:CGSize) -> [Dot] {
        

//        let xDiff = size.width / Double(res)
//        let yDiff = size.height / Double(res)
//        let x = Double(i) * xDiff + xDiff/2
//        let y = Double(j) * yDiff + yDiff/2
        let middle: (CGSize) -> CGPoint = {size in
            CGPoint(x: size.width/2, y: size.height-100)
        }
        
        let dotSize : (CGPoint, CGSize) -> Double = { point, size in
            let offset = CGPoint(x: size.width/2, y: 0) |-| point
            let s = cos((offset*Double.tau*1)/size.width*0.71)
            let result = ( s*s) * 12 + 3 //(offset * sin(point.x) + offset * cos(point.y)) / 5.0 + 35.0 /// (offset+0.1/size.width+0.1)
            //print ("zone at point:", result)
            return result
        }
        
        let p = middle(size)
        let dot = Dot(at: p, zone: dotSize(p, size))
        
        var result: [Dot] = [dot]
        var newDots: [Dot] = dot.addDots(in: size, allDots: &result, zoneClosure: dotSize)
        
        var virginDots: [Dot] = []
        var counter = 0
        while !newDots.isEmpty {
//            for _ in 0...10 {
                virginDots = []
            for newDot in newDots {
                virginDots.append(contentsOf: newDot.addDots(in: size, 
                                                             allDots: &result, 
                                                             zoneClosure: dotSize))
            }
            
            print (counter, "new dots", virginDots.count)
            counter += 1
            newDots = virginDots
        }

        return result
    }
    public init(){
        self.dots = makeDots(in: CGSize(width: 800, height: 800))
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { pos in 
               // print (pos)
                self.isDragging = true
                cursor = pos.location
                if dots.count > 1 {
                    print (dots[0].commonZone(with: dots[1], contains: cursor))
                }
            }
            .onEnded { _ in self.isDragging = false }
    
    }
   
    func dragDot(_ dot: Dot) -> some Gesture {
        DragGesture()
            .onChanged { pos in 
                print ("on dot")
                self.draggedDotPosition = pos.location
                dot.at = pos.location
            }
            .onEnded {  _ in self.draggedDotPosition = nil  }
        
    }
    public var body: some View {
        GeometryReader {proxy in
//            let dots = dots(in: proxy.size)
            ForEach(0..<dots.count, id:\.self) {dotIndex in
                let dot = dots[dotIndex]
                dot.view(color: someColor(index: dotIndex), onlyDot: true)
                    
                    .position(draggedDotPosition ?? dot.at)
                    .gesture(dragDot(dot))
            }
//            Circle().fill(Color.red)
//                .frame(width:10, height:10)
//                .position(cursor)
//            
//                .gesture(drag)
        }.background(content: {Color.white})
    }
}
