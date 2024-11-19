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
    var body: some View {
        Picker ("Map Type", selection: $selectionIndex)
        {
            Text ("Image").tag(0)
            Text ("Function").tag(1)
        }.onAppear {
            selectionIndex = mapType.index
        }.onChange(of: selectionIndex) {
            debugPrint ("CHOOSE MAP TYPE")
            mapType = selectionIndex == 0 
            ? Defaults.defaultMapImage 
            : Defaults.defaultMapFunction
            debugPrint ("CHOOSEN \(mapType)")
        }.onChange(of: mapType) {
            selectionIndex = mapType.index
        }
    }
}

