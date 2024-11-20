//
//  MapTypeChooser.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 19/11/2024.
//

import SwiftUI

struct MapTypeChooser: View {
    @Binding var mapType: MapType
    @State var selectionIndex: Int = 0
    
    var selectionBinding: Binding<Int> {
        Binding(get: {mapType.index}, 
                set: {mapType = $0 == 0 
            ? Defaults.defaultMapImage 
            : Defaults.defaultMapFunction})
    }
    
    var body: some View {
        Picker ("Map Type", selection: selectionBinding)
        {
            Text ("Image").tag(0)
            Text ("Function").tag(1)
            
        }
    }
}

#Preview {
    @Previewable @State var i = MapType
        .image(image: Defaults.imageSource, 
               filters: Defaults.filtersChain)
    @Previewable @State var change = false
    MapTypeChooser(mapType: $i)
}
