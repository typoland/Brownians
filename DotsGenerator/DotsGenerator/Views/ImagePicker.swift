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
                    print (url)
                    guard let data = try? Data(contentsOf: url) else {return}
                    if let new = NSImage(data: data)?.ciImage {
                        image = new
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
