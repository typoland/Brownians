//
//  DesignDotsView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

struct DesignDotsView: View {
    @ObservedObject var manager: Manager
    var body: some View {
        HStack {
            DotSizesView(manager: manager)
        }
    }
}

struct DotSizesView: View {
    @ObservedObject var manager: Manager
//    @State var detailValue: Double = 0.5
//    @State var strengthValue: Double = 0.5
  
//    var previewSize: Double {
//        (manager.detailDotSize * detailValue)
//        * (manager.strengthDotSize * strengthValue)
//    }
    
    func testDots(in frame:CGSize) -> [Dot] {
       
        let detail: (CGPoint) -> Double = {point in
            manager.detailSize * (1.0-point.x/frame.width)  //manager.detailSize.multiplier + manager.detailSize.minSize
        }
        
        let size : (CGPoint) -> Double = {point in
            manager.dotSize * (1.0-point.y/frame.height) // manager.dotSize//.multiplier + manager.dotSize.minSize
        }
        
        let middle = CGPoint(x: frame.width/2, 
                             y: frame.height/2)
        var dots = [Dot(at: middle, 
                        density: detail(middle), 
                        dotSize: size(middle))]
        
        DotGenerator.makeDots(in: frame, 
                              result: &dots, 
                              detailSize: detail, 
                              dotSize: size,
                              chaos: manager.chaos)
        

        return dots
    }
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    Text("Details size")
                        .alignmentGuide(.leading, computeValue: {_ in 50})
                    HStack {
                        Text("min:")
                        EnterTextFiledView("minimum", value: $manager.detailSize.minSize)
                            .alignmentGuide(.leading, computeValue: {_ in 300})
                   
                        Text("mutilplier:")
                        EnterTextFiledView("multiplier", value: $manager.detailSize.maxSize)
                    }
                }
                VStack {
                    Text("color Strength")
                    HStack {
                        Text("min:")
                        EnterTextFiledView("minimum", value: $manager.dotSize.minSize)
                        Text("mutilplier:")
                        EnterTextFiledView("multiplier", value: $manager.dotSize.maxSize)
                    }
                }
            }
            
            
            Canvas {context, size in
                print ("context \(size)")
                let dots = testDots(in: size)
                for dotIndex in 0..<dots.count {
                    let dot = dots[dotIndex]
                    let circleSize = dot.upperBound * dot.dotSize
                    let path = CircleShape().path(in: CGRect(x: dot.at.x, 
                                                             y: dot.at.y, 
                                                             width: circleSize, 
                                                             height: circleSize))
                    context.fill(path, with: .color(.black))
                }
            }.frame(width: 100, height: 100)
                .background(Color.white)
            
            
        }
    }
}
