//
//  MapImageView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//
import SwiftUI

struct MapImageView: View {
    @Binding var image: CIImage
    @Binding var filters: FiltersChain
   
    var body: some View {
        VStack {
            
            ImagePicker(image: $image)
            if filters.chain.count > 0,
                let res = try? filters.result(source: image) {
                Image(nsImage: res.nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            let bindingFilters = Binding(
                get: {filters.chain}, 
                set: {  filters = FiltersChain(chain: $0)}
            )
            
            FiltersView(filters: bindingFilters)

            Spacer()
        }
    }
}
