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
                    
                    let dataBinding = Binding(
                        get: {data as! LinearGradientData}, 
                        set: {
                            debugPrint("new data: \($0)")
                            mapType = .gradient(type: type, stops: stops, data: $0 as (any GradientData))})
                    let stopsBinding = Binding(
                        get: {stops}, 
                        set: {mapType = .gradient(type: type, stops: $0, data: data)})
                    
                    LinearGradientDataView(linearGradientData: dataBinding, 
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
