//
//  LinearGradientDataView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 23/11/2024.
//

import SwiftUI

struct LinearGradientDataView: View {
    
    @Binding var linearGradientData : LinearGradientData
    @Binding var stops: [GradientStop]
    @EnvironmentObject var manager: Manager
    @State var isDragging : Bool = false 
    @State var push: Bool = false
    
    func toSize(_ size:CGSize, point: UnitPoint) -> CGPoint {
        CGPoint(x: point.x*size.width, 
                y: point.y*size.height)
    }
    func toUnit(_ size:CGSize, point: CGPoint) -> UnitPoint {
        UnitPoint(x: point.x/size.width, 
                  y: point.y/size.height)
    }
    
    func dragStart(on size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged ({what in 
                debugPrint("SIZE:\(size)")
                debugPrint("LOC:\(what.location)")
                debugPrint("UNIT:\(toUnit(size, point: what.location))")
                if !isDragging {
                    linearGradientData.start = toUnit(size, point: what.location)
                    debugPrint("START: \(linearGradientData.start)")
                } else {
                    linearGradientData.end = toUnit(size, point: what.location)
                    debugPrint("END:\(linearGradientData.end)\n")
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
                let conrrolViewSize = CGSize(width: proxy.size.width, height: proxy.size.height / prop)
                ZStack {
                    RenderGradientView(size: conrrolViewSize, 
                                       stops: stops, 
                                       data: linearGradientData)
                                      
                    .gesture(dragStart(on: proxy.size))
                    
                }
                Text("\(linearGradientData.start) \(linearGradientData.end) \(stops.count)")
                StopsView (stops: $stops)
            }
        }
    }
}

#Preview {
    @Previewable @State var data = LinearGradientData(start: UnitPoint(x: 0, y: 0), end: UnitPoint(x: 1, y: 0))
    @Previewable @State var stops: [GradientStop] = [
        GradientStop(color: .white, location: 0),
        GradientStop(color: .black, location: 0.33),
        GradientStop(color: .white, location: 0.66),
        GradientStop(color: .black, location: 1),
    ]
    LinearGradientDataView(
        linearGradientData: $data, 
        stops: $stops).environmentObject(Manager())
}
