//
//  ContentView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import Foundation
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var manager = Manager()
    @State var refreshPreview: Bool = true
    @State var refreshDrawing: Bool = false
    @State var savePDF: Bool = false
    @State var choosePath: Bool = false
    
    
    @ViewBuilder
    var finalView : some View {
        let size = manager.finalSize
        GenerateDotsView(refresh: $refreshDrawing, 
                         savePDF: $savePDF, 
                         manager: manager)
                .frame(width:size.width, 
                       height: size.height)
     
    }
    let largeFont = NSFont.systemFont(ofSize: 60)
    var configuration = NSImage.SymbolConfiguration(textStyle: .body, scale: .large)
  
    var noPath : Bool {
        manager.resultsFolderPath == nil
    }
    var body: some View {
        HStack (spacing: 20) {
            VStack {
                
                
                GenerateDotsView(refresh: $refreshPreview, 
                                 savePDF: .constant(false), 
                                 manager: manager)
                    .frame(height: 200)
                Group {
                    if refreshPreview {
                        Button(action: {refreshPreview = false}, 
                               label: {Text("Stop")})
                    } else {
                        Text("Preview shows only true detail size, images are scaled down").lineLimit(3).controlSize(.mini)
                        
                    }
                }.frame(maxWidth: .infinity)
                    .frame(height: 30)
                HStack {
                    Text("Chaos:")
                    EnterTextFiledView("0,5...0,99", 
                                       value: $manager.chaos,
                                       in: 0.4...1)
                }
                HStack (alignment: .top) {
                    MapTypeView(title: "Detail size",
                                map: $manager.detailMap, 
                                dotSize: $manager.detailSize,
                                range: 2...Double.infinity)
                    MapTypeView(title: "Dot size",
                                map: $manager.sizeMap, 
                                dotSize: $manager.dotSize,
                                range: 0...1)
                    
                    
                    
                }
                Spacer()
            }.onSubmit {
                refreshPreview = true
            }.frame(width: 300)
            .environmentObject(manager)
            
            
            VStack {
                
                HStack {
                    ImageSizeView(size: $manager.finalSize)
                    Spacer(minLength: 200)
                    
                    Button(action: {
                        refreshDrawing.toggle()
                    }, 
                           label: {
                        Text("\(refreshDrawing ? "Stop" : " Start") Render").font(.system(size: 24))
                        refreshDrawing 
                        ? Image(systemName: "stop.circle").frame(width: 50, height: 50)
                        : Image(systemName: "play.rectangle").frame(width: 50,height: 50)
                    })
                    .buttonStyle( .borderless )
                    .controlSize( .extraLarge)

                    Text("\(manager.finalSize)")
                
                    Button (action: {
                        if noPath {
                            choosePath = true
                        } else {
                            savePDF = true
                        }
                    }, label: {Text("\(noPath ? "choose save folder ": "save PDF")")})
                    
                }.environmentObject(manager)
                
                ScrollView([.horizontal, .vertical]) {
                    let size = manager.finalSize
                    finalView
                        .environmentObject(manager) 
                        .frame(width:size.width, 
                               height: size.height)
                }
               
            }
             
        }
        .padding()
        .onChange(of: manager.sizeOwner) {
            print ("Change \(manager.sizeOwner)")
            manager.updateSizes()
        }.fileImporter(isPresented: $choosePath, 
                       allowedContentTypes: [.folder]) { result in
            switch result {
            case .success(let success):
                manager.resultsFolderPath = success
            case .failure(_):
                manager.resultsFolderPath = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
