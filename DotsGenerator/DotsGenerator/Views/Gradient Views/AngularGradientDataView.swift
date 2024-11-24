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
struct AngularGradientDataView: View {
    @Binding var angularGradientData: AngularGradientData
    @Binding var stops: [GradientStop]
    @EnvironmentObject var manager: Manager
    @State var isDragging = false
    
//    func setCenter(for size: CGSize) -> some Gesture {
//        TapGesture(count: 2)
//            .onEnded({event in
//                angularGradientData.center = event.location.unitPoint(in: size)
//            })
//    }
    func takeAngleToCenter(for point: CGPoint, in size: CGSize) -> Double {
        let c = angularGradientData.center.cgPoint(in: size)
        let d = c - point
        return (atan2(d.y, d.x)+Double.pi).truncatingRemainder(dividingBy: Double.tau) * 360 / Double.tau
    }
    func dragCenter(for size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({event in
                angularGradientData.center = event.location.unitPoint(in: size)
            })
    }
    
    func setAngles(for size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({event in
                if !isDragging {                    
                    angularGradientData.startAngle = takeAngleToCenter(for: event.location, in: size)
                } else {
                    let new = takeAngleToCenter(for: event.location, in: size)
                    angularGradientData.endAngle = new < angularGradientData.startAngle 
                    ? new + 360 : new
                    
                }
                isDragging = true
            })
            .onEnded({event in
//                angularGradientData.endAngle = takeAngleToCenter(for: event.location, in: size)
                isDragging = false
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
                                       data: angularGradientData)
                    .frame(width: conrrolViewSize.width,
                           height: conrrolViewSize.height)
                    .gesture(setAngles(for: conrrolViewSize))
                    .overlay {
                        
                        Circle()
                            .fill(Color.red)
                            .position(angularGradientData.center.cgPoint(in: conrrolViewSize).shifted(in: conrrolViewSize))
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
