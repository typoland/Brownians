//
//  MapGradientView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 22/11/2024.
//

import SwiftUI

struct MapGradientView: View {
    @Binding var mapType: MapType
    @State var choosen: MapType.GradientType = .linear
    //@Binding var data: GradientData
    
    func gradient(size: CGSize) -> NSImage {
        let flatten = mapType.faltten(to: size)
        if case .image(let image, _) = flatten {
            return image.image.nsImage
        }
        return Defaults.image.nsImage
    }
    
    
    
    var body: some View {
        VStack {
            if case .gradient(let type, let stops, let data) = mapType {
                //            let dataBinding = Binding(get: {data}, 
                //                                      set: {mapType = .gradient(type: type, stops: stops, data: $0)})
                
                
                Picker("gradient type", selection: $choosen) { 
                    ForEach(MapType.GradientType.allCases, id:\.stringValue) { type in
                        Text("\(type.stringValue.capitalized)").tag(type)
                    }
                }
                               
                
                switch type {
                case .angular:
                    Text("angular")
                case .eliptical:
                    Text("eliptical")
                case .linear:
                    
                    let bindingStart = Binding(
                        get: {(data as! LinearGradientData).start}, 
                        set: {newStart in
                            let end = (data as! LinearGradientData).end
                            mapType = .gradient(type: type, 
                                                stops: stops, 
                                                data: LinearGradientData(start: newStart, end: end))})
                    let bindingEnd = Binding(
                        get: {(data as! LinearGradientData).end}, 
                        set: {newEnd in
                            let start = (data as! LinearGradientData).start
                            mapType = .gradient(type: type, 
                                                stops: stops, 
                                                data: LinearGradientData(start: start, end: newEnd))})
                    let stopsBinding = Binding(
                        get: {stops}, 
                        set: {mapType = .gradient(type: type, stops: $0, data: data)})
                    
                    LinearGradientDataView(start: bindingStart, 
                                           end: bindingEnd, 
                                           stops: stopsBinding)
                }
                
            }
        }
    }
    
    //Rectangle().fill(type)
}


//#Preview {
//    MapGradientView()
//}
