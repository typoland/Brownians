//
//  ImagePicker.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import SwiftUI
struct ImagePicker: View {
    @Binding var imageSource: ImageSource
    @State var isImporting: Bool = false
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        VStack {
            Image(nsImage: imageSource.image.nsImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Button (action: {
                isImporting = true
            }, label: {Text("open Image")})
            .buttonStyle(.borderless )
            .controlSize(.mini)
            .fileImporter(isPresented: $isImporting, 
                          allowedContentTypes: [.png, .jpeg, .tiff], 
                          onCompletion: { result in
                
                switch result {
                case .success(let url):
                    // url contains the URL of the chosen file.
                    guard let _ = try? Data(contentsOf: url) else {return}
                    imageSource = .url(url: url)
                    manager.updateSizes()
                    
                case .failure(let error):
                    print(error)
                }
            })
        }
    }
}
