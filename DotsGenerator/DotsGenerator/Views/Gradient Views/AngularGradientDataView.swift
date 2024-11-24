//
//  AngularGradientDataView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 24/11/2024.
//

import SwiftUI

extension CGPoint {
    func shifted(in size: CGSize) -> CGPoint {
        CGPoint(x: x-size.width/2, 
                y: y-size.height/2)
    }
}

extension UnitPoint {
    func shifted(in size: CGSize) -> UnitPoint {
        UnitPoint(x: x+0.5, 
                  y: y+0.5)
    }
}
struct AngularGradientDataView: View {
    @Binding var angularGradientData: AngularGradientData
    @Binding var stops: [GradientStop]
    @EnvironmentObject var manager: Manager
    @State var isDragging = false
    
    func dragCenter(for size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({event in
                angularGradientData.center = event.location
                    .unitPoint(in: size)
                    .shifted(in: size)
            })
    }
    
    func setAngles(for size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({event in
                if !isDragging {                    
                    angularGradientData.startAngle 
                    = angularGradientData.center.cgPoint(in: size).angleTo(event.location)
                   // takeAngleToCenter(for: event.location, in: size)
                } else {
                    let new = angularGradientData.center.cgPoint(in: size).angleTo(event.location)
                    angularGradientData.endAngle = new < angularGradientData.startAngle 
                    ? new + 360 : new
                }
                isDragging = true
            })
            .onEnded({event in
                isDragging = false
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
                                       data: angularGradientData)

                    .gesture(setAngles(for: conrrolViewSize))
                    .overlay {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .position(angularGradientData
                                .center.cgPoint(in: conrrolViewSize)
                                .shifted(in: conrrolViewSize) + CGPoint(x: 4, y: 4)
                            )
                            .gesture(dragCenter(for: conrrolViewSize))
                            .frame(width: 8, height:8)
                    }
                        
                    
                        
                    
                } 
                StopsView (stops: $stops)
            }
        }
    }
}


#Preview {
    @Previewable @State var data = AngularGradientData()
    @Previewable @State var stops: [GradientStop] = [
        GradientStop(color: .awhite, location: 0),
        GradientStop(color: .ablack, location: 0.33),
        GradientStop(color: .awhite, location: 0.66),
        GradientStop(color: .ablack, location: 1),
    ]
    AngularGradientDataView(
        angularGradientData: $data, 
        stops: $stops)
    .environmentObject(Manager())
}
