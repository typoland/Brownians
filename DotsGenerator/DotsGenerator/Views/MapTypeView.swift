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
    
    var bindingFunction: Binding<CustomFunction> {
        Binding(get: {
            if case .function(let function) = map {
                return function
            }
            fatalError()
        }, set: {
            map = .function(function: $0)
        })
    }
    
    var bindingImageFilters: Binding<FiltersChain> {
        Binding(get: {
            if case .image(_, let filtersChain) = map {
                return filtersChain
            }
            fatalError()
        }, set: {
            if case .image(let source, _) = map {
                map = .image(image: source, filters: $0)
            }
        })
    }
    
    var bindingImageSource: Binding<ImageSource> {
        Binding(get: {
            if case .image(let source, _) = map {
                return source
            }
            fatalError()
        }, set: {
            if case .image( _, let filtersChain) = map {
                map = .image(image: $0, filters: filtersChain)
            }
        })
    }
    
    var body: some View {
        VStack {
            Text(title)
            
            SizesView(dotSize: $dotSize, range: range)

            MapTypeChooser(mapType: $map)
            
            switch map {
            case .function:

                MapFunctionView(function: bindingFunction)
                
            case .image:

                MapImageView(imageSource: bindingImageSource, 
                             filters: bindingImageFilters)
                
            }
        }
    }
}

#Preview {
    @Previewable @State var i = MapType
        .image(image: Defaults.imageSource, 
               filters: Defaults.filtersChain)
    @Previewable @State var size = DotSize(minSize: 10, maxSize: 20)
    MapTypeView(title: "test",map: $i, dotSize: $size, range: 0...1000).environmentObject(Manager())
}







