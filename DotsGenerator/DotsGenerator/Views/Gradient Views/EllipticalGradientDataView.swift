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
    
    
    func dragCenter(for size: CGSize) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged({event in
                ellepticalGradientData.center = event.location
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
                    ellepticalGradientData.endRadiusFraction  =  ellepticalGradientData.startRadiusFraction 
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
                            .fill(Color.white.opacity(0.2))
                            .border(.gray)
                            .position(ellepticalGradientData
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
