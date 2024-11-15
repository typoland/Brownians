//
//  ImageSizeView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

struct ImageSizeView: View {
    @Binding var size: CGSize
    @EnvironmentObject var manager: Manager
    var body: some View {
        HStack {
            let disabled = manager.sizeOwner != .manager
            Text("width:")  
            
            EnterTextFiledView("width",
                               value: $size.width,
                               in: 0...10000)
            .disabled(disabled)
            
            
            Text("height:")
            EnterTextFiledView("height",
                               value: $size.height,
                               in: 0...10000)
            .disabled(disabled)
            
            Text("size owner")
            SizeOwnerChooser()
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
        Picker("", selection: $manager.sizeOwner) {
            Text("program")
                .tag(Manager.SizeOwner.manager)
            if case .image(_,_) = manager.detailMap {
                Text("detail Map")
                    .tag(Manager.SizeOwner.detailMap)
            }
            if case .image(_,_) = manager.sizeMap {
                Text("strength Map")
                    .tag(Manager.SizeOwner.sizeMap)
            }
        }
    }
}
