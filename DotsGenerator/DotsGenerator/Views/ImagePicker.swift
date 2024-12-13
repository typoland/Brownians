//
//  ImagePicker.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import SwiftUI

struct ImagePicker: View {
    @Binding var imageSource: ImageSource
    @EnvironmentObject var manager: Manager
    @State var showSheet: Bool = false
    
    func showPanel() -> URL?  {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.jpeg, .png, .tiff]
        let result = openPanel.runModal()
        return result == .OK ? openPanel.url : nil
    }
    
    var body: some View {
        VStack {
            Image(nsImage: imageSource.image.nsImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Button(action: {
                guard let url = showPanel(),
                      let _ = try? Data(contentsOf: url) else { return } 
                imageSource = .url(url: url)
                manager.updateSizes()    
                    showSheet  = true
                    print("after", showSheet)
              
            },
                   label: { Text("open Sheet") })
            .buttonStyle(.borderless)
            .controlSize(.mini)
        }
    }
}
