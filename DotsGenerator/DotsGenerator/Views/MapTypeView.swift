//
//  DetailMapView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import SwiftUI

struct MapTypeView: View {
    var title: String
    @Binding var map: MapType
    @Binding var dotSize: DotSize
    var sizeOwner: Manager.SizeOwner
    var range: ClosedRange<Double>
    @EnvironmentObject var manager: Manager
    

    
    
    var body: some View {
        VStack {
            Text(title)
            
            SizesView(dotSize: $dotSize, range: range)

            MapTypeChooser(mapType: $map)
            
            switch map {
            case .function( let function):
                let binding = Binding(get: {function}, 
                                      set: {
                    map = .function(function: $0)
                    if sizeOwner == manager.sizeOwner {
                        manager.sizeOwner = .manager
                    }
                })
                MapFunctionView(function: binding)
                
            case .image(image: let image, filters: let filtersChain):
                let imageBinding = Binding(get: {image}, 
                                           set: {map = .image(image: $0, filters: filtersChain)})
                let filtersBinding = Binding(get: {filtersChain}, 
                                           set: {map = .image(image: image, filters: $0)})
                MapImageView(imageSource: imageBinding, 
                             filters: filtersBinding)
                
            case .gradient(let type, let stops, let data):
                let stopsBinding = Binding(
                    get: {stops}, 
                    set: {
                        map = .gradient(type: type, stops: $0, data: data)
                        if sizeOwner == manager.sizeOwner {
                            manager.sizeOwner = .manager
                        }
                    })
                
                let typeBinding = Binding (
                    get: {type}, 
                    set: {
                        if $0 != type {
                        switch $0 {
                            
                        case .angular:
                            map = .gradient(type: .angular, 
                                            stops: stops, 
                                            data: AngularGradientData())
                        case .eliptical:
                            map = .gradient(type: .eliptical, 
                                                    stops: stops, 
                                            data: ElipticalGradientData())
                        case .linear:
                            map = .gradient(type: .linear, 
                                            stops: stops, 
                                            data: LinearGradientData())
                        }
                    }})
                
                let dataBinding = Binding (
                    get: {data}, 
                    set: {
                        map = .gradient(type: type, stops: stops, data: $0)
                    })
                
                MapGradientView(
                    type: typeBinding, 
                    stops: stopsBinding, 
                    data: dataBinding)
            }
        }
    }
}

#Preview {
    @Previewable @State var i = MapType
        .image(image: Defaults.imageSource, 
               filters: Defaults.filtersChain)
    @Previewable @State var size = DotSize(minSize: 10, maxSize: 20)
    MapTypeView(title: "test",map: $i, dotSize: $size, sizeOwner: .manager, range: 0...1000).environmentObject(Manager())
}







