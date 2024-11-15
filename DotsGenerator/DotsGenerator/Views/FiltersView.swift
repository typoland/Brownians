//
//  FiltersView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//
import SwiftUI

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
                        }) { Image(systemName: "trash")}
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                    Divider()
                    FiltersChooser(filterName: bindFilters(index: index+1))
                    
                }
                
            }
           
        }
    }
}
