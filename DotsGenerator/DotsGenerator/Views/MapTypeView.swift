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
    @Binding var size: Manager.DotSize
    var range: ClosedRange<Double>
    var body: some View {
        VStack {
            VStack {
                Text("\(title)")
                    .alignmentGuide(.leading, computeValue: {_ in 50})
                HStack {
                    Text("min:")
                    EnterTextFiledView("minimum", 
                                       value: $size.minSize,
                                       in: range)
                        //.onSubmit { Task { await makeDots(in: previewSize) }}
                }
                HStack {
                    Text("max:")
                    EnterTextFiledView("maximum", 
                                       value: $size.maxSize,
                                       in: range)
                        //.onSubmit { Task { await makeDots(in: previewSize) }}
                }
            }
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
            
        }
        
    }
}

#Preview {
    @Previewable @State var v = MapType.number(value: 0.5)
    @Previewable @State var i = MapType.image(image: Defaults.ciImage, filters: Defaults.filtersChain)
    @Previewable @State var f = MapType.number(value: 0.5)
    @Previewable @State var size = Manager.DotSize(maxSize: 10, minSize: 30)
    MapTypeView(title: "test",map: $i, size: $size, range: 0...1000)
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






