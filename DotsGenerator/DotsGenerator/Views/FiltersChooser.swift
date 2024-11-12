//
//  FiltersChooser.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

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
