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
            
//            let nameBinding = Binding(
//                get: {map.name}, 
//                set: {map = MapType($0)})
            MapTypeChooser(mapType: $map)
            
            switch map {
            case .function(let function):
                
                let binding = Binding(get: {function}, 
                                      set: {map =  .function(function: $0)})
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
                                       filters: filtersChain)
                        debugPrint("new map: \(map)")
                    })
                MapImageView(imageSource: bindingImage, 
                             filters: bindingChain)
                
            }
        }
    }
}

#Preview {
    @Previewable @State var i = MapType
        .image(image: Defaults.imageSource, 
               filters: Defaults.filtersChain)
    @Previewable @State var size = DotSize(minSize: 10, maxSize: 20)
    MapTypeView(title: "test",map: $i, dotSize: $size, range: 0...1000)
}







