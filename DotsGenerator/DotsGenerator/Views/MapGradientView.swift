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
    
    

    
    
    var body: some View {
        var gradientTypeBinding = Binding(
            get: {
                if case .gradient(let type, _, _) = mapType {
                return type 
            } else {fatalError("map type is not gradient \(mapType)")} }, 
            set: {newType in
                if case .gradient(_, let stops, _) = mapType {
                    switch newType {
                    case .linear:
                        mapType = .gradient(type: .linear, stops: stops, data: LinearGradientData())
                    case .angular:
                        mapType = .gradient(type: .angular, stops: stops, data: AngularGradientData())
                    case .eliptical:
                        mapType = .gradient(type: .eliptical, stops: stops, data: ElipticalGradientData())
                    }
                }
            })
        VStack {
            if case .gradient(let type, let stops, let data) = mapType {
                
                
                
                Picker("gradient type", selection: gradientTypeBinding) { 
                    ForEach(MapType.GradientType.allCases, id:\.stringValue) { type in
                        Text("\(type.stringValue.capitalized)").tag(type)
                    }
                }
                
                let stopsBinding = Binding(
                    get: {stops}, 
                    set: {mapType = .gradient(type: type, stops: $0, data: data)}) 
                
                switch type {
                case .angular:
                    Text("angular")
                    
                    
                case .eliptical:
                    let dataBinding = Binding(
                        get: {data as! ElipticalGradientData}, 
                        set: {mapType = .gradient(type: type, stops: stops, data: $0 )})
                    EllipticalGradientDataView(
                        ellepticalGradientData: dataBinding, 
                        stops: stopsBinding)
                    
                case .linear:
                    let dataBinding = Binding(
                        get: {data as! LinearGradientData}, 
                        set: {mapType = .gradient(type: type, stops: stops, data: $0 )})
                    
                    
                    LinearGradientDataView(
                        linearGradientData: dataBinding, 
                        stops: stopsBinding)
                }
                
            }
            Text("choosen \(choosen)")
        }
    }
    
    //Rectangle().fill(type)
}


//#Preview {
//    MapGradientView()
//}
