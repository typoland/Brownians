//
//  MapGradientView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 22/11/2024.
//

import SwiftUI

struct MapGradientView: View {
    @Binding var mapType: MapType
    @State var choosen: MapType.GradientType = .linear
    //@Binding var data: GradientData
    
    func gradient(size: CGSize) -> NSImage {
        let flatten = mapType.faltten(to: size)
        if case .image(let image, _) = flatten {
            return image.image.nsImage
        }
        return Defaults.image.nsImage
    }
    var body: some View {
        if case .gradient(let type, let data) = mapType {
            
            VStack {
//                let typeBinding = Binding(get: {type}, 
//                                          set: {mapType = .gradient(type: $0, data: data)})
                let dataBinding = Binding(get: {data}, 
                                          set: {mapType = .gradient(type: type, data: $0)})
                Picker("gradient type", selection: $choosen) { 
                    ForEach(MapType.GradientType.allCases, id:\.stringValue) { type in
                        Text("\(type.stringValue.capitalized)").tag(type)
                    }
                }
                Text ("Choosen \(choosen)")
                let size = CGSize(width: 100, height: 100)
                Image(nsImage: gradient(size: size))
                
            }.onAppear {
                if case .gradient(let type, _) = mapType {
                    choosen = type
                }
            }
        }
    }
    
    //Rectangle().fill(type)
}


//#Preview {
//    MapGradientView()
//}
