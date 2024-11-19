//
//  ImagePicker.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import SwiftUI
struct ImagePicker: View {
    @Binding var image: CIImage
    @State var isImporting: Bool = false
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        VStack {
            Image(nsImage: image.nsImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Button (action: {
                isImporting = true
            }, label: {Text("open Image")})
            .fileImporter(isPresented: $isImporting, 
                          allowedContentTypes: [.png, .jpeg, .tiff], 
                          onCompletion: { result in
                
                switch result {
                case .success(let url):
                    // url contains the URL of the chosen file.
                    guard let data = try? Data(contentsOf: url) else {return}
                    if let new = NSImage(data: data)?.ciImage {
                        image = new
                        manager.updateSizes()
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
