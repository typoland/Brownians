//
//  EllipticalGradientDataView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 24/11/2024.
//

import SwiftUI

struct EllipticalGradientDataView: View {
    @Binding var ellepticalGradientData: ElipticalGradientData
    @Binding var stops: [GradientStop]
    @State var isDragging = false
    @EnvironmentObject var manager: Manager
    
    let cursorSize = 8.0
    
    func dragCenter(for size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({event in
                ellepticalGradientData.center = (
                    CGPoint(x:event.location.x - cursorSize/2,
                            y:event.location.y - cursorSize/2))
                .unitPoint(in: size)
                    .shifted(in: size)
            })
    }
    
    func setARadiuses(for size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({event in
                if !isDragging {                    
                    ellepticalGradientData.startRadiusFraction 
                    = ellepticalGradientData.center.distance(to: event.location.unitPoint(in: size))
                    // takeAngleToCenter(for: event.location, in: size)
                } else {
                    let new = ellepticalGradientData.center.distance(to: event.location.unitPoint(in: size))
                    ellepticalGradientData.endRadiusFraction  =  new
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
                                       data: ellepticalGradientData)
                    .gesture(setARadiuses(for: conrrolViewSize))
                    .overlay {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .stroke(.gray)
                            .position(ellepticalGradientData
                                .center.cgPoint(in: conrrolViewSize)
                                .shifted(in: conrrolViewSize) 
                                      + CGPoint(x: cursorSize/2, 
                                                y: cursorSize/2)
                            )
                            .frame(width: cursorSize, height:cursorSize)
                            .gesture(dragCenter(for: conrrolViewSize))
                    }
                } 
                
                
                StopsView (stops: $stops)
            }
        }
    }
}


#Preview {
    @Previewable @State var data = ElipticalGradientData()
    @Previewable @State var stops: [GradientStop] = [
        GradientStop(color: .awhite, location: 0),
        GradientStop(color: .ablack, location: 0.33),
        GradientStop(color: .awhite, location: 0.66),
        GradientStop(color: .ablack, location: 1),
    ]
    EllipticalGradientDataView(
        ellepticalGradientData: $data, 
        stops: $stops)
    .environmentObject(Manager())
}
