//
//  StopsView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 22/11/2024.
//

import SwiftUI
struct StopsView: View {
    @Binding var stops: [GradientStop]
    @State var selectedStop: Int? = nil
    @State var isDragging: Bool = false
    let boxWidth = 10.0
    func toLocal(_ number: Double, 
                 in width: Double) -> Double {
        width * number - width/2 + boxWidth / 2
    }
    
    
    func dragBox(_ index: Int, width: Double) -> some Gesture {
        DragGesture(minimumDistance: 2, coordinateSpace: .local) 
            .onChanged({event in isDragging = true
                let v = (event.location.x + width/2) / width
                if index == 0, 
                    stops[1].location > v, 
                    v >= 0 
                {
                    stops[0].location = v
                } else if index == stops.count-1 , 
                            stops[stops.count-2].location < v,
                v <= 1{
                    stops[index].location = v
                } else  if index > 0, 
                    stops[index-1].location < v,
                   index < (stops.count-1), 
                    stops[index+1].location > v {
                    stops[index].location = v
                }
                
            })
            .onEnded({_ in isDragging = false})
    }
    
    @ViewBuilder
    func StopBox(index: Int, in size: CGSize) -> some View {
        Circle()
            .fill(stops[index].color.system)
            .position(x: toLocal(stops[index].location, 
                                 in: size.width), 
                      y: 18)
            .frame(width: boxWidth, 
                   height: boxWidth)
            .gesture(dragBox(index, width: size.width))
            .onTapGesture(count: 2, perform: {
                stops[index].color = stops[index].color == .awhite ? .ablack : .awhite
            })
            .onTapGesture {
                selectedStop = index
            }.contextMenu {
                Button(action: {
                    stops.remove(at: index)
                }, label: { Label("Delete", systemImage: "icon") })
            }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Group {
            GeometryReader {proxy in
          
                
                    ZStack {
                        ForEach((0..<stops.count).indices, id:\.self) {index in
                            StopBox(index: index, in: proxy.size)
                                .onTapGesture {
                                    selectedStop = nil
                                }
                        }
                        
                    }
                    .frame(width: proxy.size.width, height: 12)
                
                    .background(.linearGradient(
                        Gradient(stops: stops.map{$0.gradient_stop}), 
                        startPoint: UnitPoint(x: 0, y: 0), 
                        endPoint: UnitPoint(x: 1, y: 0)))
                    .onTapGesture(count: 2, perform: {event in 
                        let location = event.x/proxy.size.width
                        if let index = stops.firstIndex(where: {$0.location > location}) {
                            stops.insert(GradientStop(color: .awhite, location: location), at: index )
                        }
                    })
                    
                    
            }
            }.frame(width: 200)
            
    }
    }
}

#Preview {
    @Previewable @State var stops = [
        GradientStop(color: .awhite, location: 0),
        GradientStop(color: .ablack, location: 0.45),
        GradientStop(color: .awhite, location: 0.5),
        GradientStop(color: .ablack, location: 0.8),
        GradientStop(color: .awhite, location: 1),
    ]
    StopsView(stops: $stops)
}
