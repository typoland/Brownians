//
//  LinearGradientDataView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 23/11/2024.
//

import SwiftUI

extension UnitPoint {
    func cgPoint(in size: CGSize) -> CGPoint {
        CGPoint(x: x*size.width, 
                y: y*size.height)
    }
    
    func distance(to point: UnitPoint) -> Double {
        let x = self.x - point.x
        let y = self.y - point.y
        return sqrt(x*x + y*y)
    }
}

extension CGPoint {
    func unitPoint(in size: CGSize) -> UnitPoint {
        UnitPoint(x: x/size.width, 
                  y: y/size.height)
    }
    
    func angleTo(_ point: CGPoint) -> Double {
        let d =   self - point
        return (atan2(d.y, d.x)+Double.pi).truncatingRemainder(dividingBy: Double.tau) * 360 / Double.tau
    }
}

struct LinearGradientDataView: View {
    
    @Binding var linearGradientData : LinearGradientData
    @Binding var stops: [GradientStop]
    @EnvironmentObject var manager: Manager
    @State var isDragging : Bool = false 
    @State var push: Bool = false
    
//    func toSize(_ size:CGSize, point: UnitPoint) -> CGPoint {
//        CGPoint(x: point.x*size.width, 
//                y: point.y*size.height)
//    }
//    func toUnit(_ size:CGSize, point: CGPoint) -> UnitPoint {
//        UnitPoint(x: point.x/size.width, 
//                  y: point.y/size.height)
//    }
//    
    func dragStart(on size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged ({what in 
                if !isDragging {
                    linearGradientData.start = what.location.unitPoint(in: size)
                } else {
                    linearGradientData.end = what.location.unitPoint(in: size)
                }
                push.toggle()
                isDragging = true
            })
            .onEnded ({what in 
                isDragging = false
                push.toggle()
            })
    }
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
                let prop = manager.finalSize.width/manager.finalSize.height
                let conrrolViewSize = CGSize(width: proxy.size.width, 
                                             height: proxy.size.width / prop)
                ZStack {
                    
                    RenderGradientView(size: conrrolViewSize, 
                                       stops: stops, 
                                       data: linearGradientData)
                                      
                    .gesture(dragStart(on: conrrolViewSize))
                    .overlay {
                        Circle().fill(.green)
                            .frame(width: 2, height: 2)
                            .position(linearGradientData.start.cgPoint(in: conrrolViewSize))
                        Circle().fill(.red)
                            .frame(width: 2, height: 2)
                            .position(linearGradientData.end.cgPoint(in: conrrolViewSize))
                    }
                }
                StopsView (stops: $stops)
            }
        }
    }
}

#Preview {
    @Previewable @State var data = LinearGradientData(start: UnitPoint(x: 0, y: 0), end: UnitPoint(x: 1, y: 0))
    @Previewable @State var stops: [GradientStop] = [
        GradientStop(color: .awhite, location: 0),
        GradientStop(color: .ablack, location: 0.33),
        GradientStop(color: .awhite, location: 0.66),
        GradientStop(color: .ablack, location: 1),
    ]
    LinearGradientDataView(
        linearGradientData: $data, 
        stops: $stops)
    .environmentObject(Manager())
}
