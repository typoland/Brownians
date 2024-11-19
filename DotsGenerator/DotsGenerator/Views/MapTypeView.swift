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
    var range: ClosedRange<Double>
    var body: some View {
        VStack {
            Text(title)
            SizesView(dotSize: $dotSize, range: range)
            let nameBinding = Binding(
                get: {map.name}, 
                set: {map = MapType($0)})
            MapTypeChooser(mapName: nameBinding)
            
            switch map {
            case .function(let function):
                
                let binding = Binding(get: {function}, 
                                      set: {map =  .function($0)})
                MapFunctionView(function: binding)
                
            case .image(let image, 
                        let filtersChain):

                let bindingChain = Binding(
                    get: {filtersChain}, 
                    set: {map = .image(image: image, 
                                       filters: $0)})
                let bindingImage = Binding(
                    get: {image}, 
                    set: {map = .image(image: $0, 
                                       filters: filtersChain)})
                MapImageView(image: bindingImage, 
                             filters: bindingChain)
                
            }
        }
    }
}

#Preview {
    @Previewable @State var i = MapType
        .image(image: Defaults.ciImage, 
               filters: Defaults.filtersChain)
    @Previewable @State var size = DotSize(minSize: 10, maxSize: 20)
    MapTypeView(title: "test",map: $i, dotSize: $size, range: 0...1000)
}

struct SizesView: View {
    @Binding var dotSize: DotSize
    var range: ClosedRange<Double>
    var body: some View {
        VStack {
            //                            Text("\(title)")
            //                                .alignmentGuide(.leading, computeValue: {_ in 50})
            HStack {
                Text("min:")
                EnterTextFiledView("minimum", 
                                   value: $dotSize.minSize,
                                   in: range)
                //.onSubmit { Task { await makeDots(in: previewSize) }}
            }
            HStack {
                Text("max:")
                EnterTextFiledView("maximum", 
                                   value: $dotSize.maxSize,
                                   in: range)
                //.onSubmit { Task { await makeDots(in: previewSize) }}
            }
        }
    }
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






