//
//  MapImageView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//
import SwiftUI

struct MapImageView: View {
    @Binding var imageSource: ImageSource
    @Binding var filters: FiltersChain
   
    var body: some View {
        VStack {
            
            ImagePicker(imageSource: $imageSource)
            if filters.chain.count > 0,
               let res = try? filters.result(source: imageSource).image {
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
