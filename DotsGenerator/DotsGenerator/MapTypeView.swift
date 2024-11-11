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
            case .none(value: let value):
                let binding = Binding(get: {value}, 
                                      set: {map = .none(value: $0)})
                MapValueView(value: binding) 
            }
        }
    }
}

#Preview {
    @Previewable @State var v = MapType.none(value: 0.5)
    @Previewable @State var i = MapType.image(image: Defaults.ciImage, filters: Defaults.chain)
    @Previewable @State var f = MapType.none(value: 0.5)
    MapTypeView(map: $i)
}



struct MapFunctionView: View {
    var function: (CGPoint) -> Double
    var body: some View {
        Text("\(String(describing: function))")
    }
}

struct MapImageView: View {
    @Binding var image: CIImage
    @Binding var filters: FiltersChain?
    var body: some View {
        VStack {

            ImagePicker(image: $image)
                
                
            if let res = try? filters?.result(source: image) {
                Image(nsImage: res.nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
            }
            let bindingFilters = Binding(
                get: {filters?.chain ?? [] as [Filters]}, 
                set: { 
                    switch (filters == nil, $0.isEmpty) {
                    case (true, true): filters = nil
                    case (true, false) : filters = FiltersChain(chain: $0)
                    case (false, true) : filters = nil 
                    case (false, false) : filters?.chain = $0 
                    }
                })
            
            FiltersView(filters: bindingFilters)
            
        }
    }
}

struct MapValueView: View {
    @Binding var value: CGFloat
    var body: some View {
        TextField("value:", value: $value, formatter: NumberFormatter())
    }
}

struct FiltersView: View {
    @Binding var filters: [Filters]
    
    func bindFilters(index: Int) -> Binding<Optional<String>> {
        Binding(
            get: {nil}, 
            set: {filterName in
               
                if let filterName {
                    insert(filterName: filterName, at: index)
                }
            }) 
    }
    
    
    func insert(filterName: String, at elementIndex: Int) {
        
        if let filter = try? Filters(name: filterName) {
            print ("somethin happened \(filter) \(elementIndex)")
            elementIndex > filters.count 
            ? filters.append(filter)
            : filters.insert(filter, at: elementIndex)
        }
    }
    func remove(at elementIndex: Int) {
        filters.remove(at: elementIndex)
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 3){
                
                FiltersChooser(filterName: bindFilters(index: 0))
                
                ForEach((0..<filters.count).indices, id: \.self) {
                    index in
                    let bindingFilter = Binding(get: {filters[index]}, 
                                                set: {filters[index] = $0})
                    Divider()
                    HStack (alignment: .top) {
                        FilterView(filter: bindingFilter)
                        Button (action: {
                            remove(at: index)
                        }) {Image(systemName: "trash")}
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                    Divider()
                    FiltersChooser(filterName: bindFilters(index: index+1))
                    
                    
                    
                }
                Spacer()
            }
           
        }
    }
}
struct FiltersChooser : View {

    @Binding var filterName: String?

    var body: some View {
        HStack {
            Spacer()
            Picker(selection: $filterName) {
                if filterName == nil {
                    Text ("").tag(nil as Optional<String>)
                }
                ForEach( (0..<Filters.names.count).indices, id:\.self) {index in
                    let name = Filters.names[index]
                    Text(name).tag(name as Optional)
                }
            } label: {
                Text("insert Filter")
            }
            .pickerStyle(.menu)
            .controlSize(.small)
            .frame(width: 102)
        }
            
    }
}
