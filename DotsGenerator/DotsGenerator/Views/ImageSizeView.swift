//
//  ImageSizeView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

struct ImageSizeView: View {
    
    @Binding var size: CGSize
    @State var scale: Double = 1.0
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        HStack {
            SizeOwnerChooser()
            
            let disabled = manager.sizeOwner != .manager
            if !disabled {
                Text("Width:")  
                EnterTextFiledView("width",
                                   value: Binding(get: {Double(size.width)}, 
                                                  set: {size.width = $0}),
                                   in: 0...10000)
                .frame(width: 50)
                
                
                Text("Height:")
                EnterTextFiledView("height",
                                   value: Binding(get: {Double(size.height)}, 
                                                  set: {size.height = $0}),
                                   in: 0...10000)
                .frame(width: 50)
            } else {
                Text("Scale:")
                EnterTextFiledView("scale", value: $manager.finalScale, in: 0.2...10)
                    .frame(width: 35)
            }            
        }
    }
}

#Preview {
    @Previewable @State var size = CGSize(width: 100, height: 100)
    ImageSizeView(size: $size)
}

struct SizeOwnerChooser: View {
    
    @EnvironmentObject var manager: Manager
    var body: some View {
        
        HStack{
            Text("Size:")
            Picker("size Owner", selection: Binding(get: {manager.sizeOwner}, 
                                                    set: {manager.sizeOwner = $0}) ) {
                Text("program")
                    .tag(Manager.SizeOwner.manager)
                if case .image(let image,_) = manager.detailMap {
                    let size = image.image.extent.size
                    Text("detail Map (\(Int(size.width))×\(Int(size.height)))")
                        .tag(Manager.SizeOwner.detailMap)
                }
                if case .image(let image,_) = manager.sizeMap {
                    let size = image.image.extent.size
                    Text("strength Map (\(Int(size.width))×\(Int(size.height)))")
                        .tag(Manager.SizeOwner.sizeMap)
                }
            }
        }.frame(minWidth: 200)
    }
}
