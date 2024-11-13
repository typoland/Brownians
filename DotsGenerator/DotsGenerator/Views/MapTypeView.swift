//
//  DetailMapView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import SwiftUI

struct MapTypeView: View {
    
    @Binding var map: MapType
    
    var body: some View {
        VStack {
            let nameBinding = Binding(get: {map.name}, 
                                      set: {map = MapType($0)})
            MapTypeChooser(mapName: nameBinding)
                
            
            switch map {
            case .function(let function):
                MapFunctionView(function: function)
            case .image(image: let image, 
                        filters: let filtersChain):
                let bindingChain = Binding(get: {filtersChain}, 
                                      set: {map = .image(image: image, filters: $0)})
                let bindingImage = Binding(get: {image}, 
                                           set: {map = .image(image: $0, filters: filtersChain)})
                MapImageView(image: bindingImage, 
                             filters: bindingChain)
            case .number(value: let value):
                let binding = Binding(get: {value}, 
                                      set: {map = .number(value: $0)})
                MapValueView(value: binding) 
            }
            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var v = MapType.number(value: 0.5)
    @Previewable @State var i = MapType.image(image: Defaults.ciImage, filters: Defaults.filtersChain)
    @Previewable @State var f = MapType.number(value: 0.5)
    MapTypeView(map: $i)
}

struct MapTypeChooser: View {
    @Binding var mapName: String
    var body: some View {
        Picker (selection: $mapName, 
                content: {
            ForEach(MapTypeNames.allCases, id:\.rawValue) {index in
                Text("\(index)").tag(index)
            }
        }) {
            Text("map type")
        }
    }
}






