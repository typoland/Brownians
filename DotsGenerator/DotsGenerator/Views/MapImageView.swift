//
//  MapImageView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//
import SwiftUI

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
            
           
            
            Spacer()
        }
    }
}
