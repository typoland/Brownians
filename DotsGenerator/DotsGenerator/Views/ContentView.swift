//
//  ContentView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import Foundation
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var manager: Manager
    
    @State var refreshDrawing: Bool = false
    @State var savePDF: Bool = false
    @State var choosePath: Bool = false
   
    @State var somethingChanged: Bool = false
    @ViewBuilder
    var finalView : some View {
        let size = manager.finalSize
        GenerateDotsView(refresh: $refreshDrawing, 
                         savePDF: $savePDF)
        .environmentObject(manager)
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
            
            ManagerSetupView()
                .environmentObject(manager)
                .frame(width: 350) 
            
            VStack {
                HStack {
                    ImageSizeView(size: $manager.finalSize)
                    Spacer(minLength: 100)
                    
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
                    }, label: {Text("\(noPath ? "choose save folder ": "save PDF")")}
                    ).fileImporter(isPresented: $choosePath, 
                                   allowedContentTypes: [.folder]) { result in
                        if case .success(let url) = result {
                            manager.resultsFolderPath = url
                        }
                        print ("try to laoad")}
                    
                }.environmentObject(manager)
                
                
                
                ScrollView([.horizontal, .vertical]) {
                    let size = manager.finalSize
                    finalView
                        .frame(width:size.width, 
                               height: size.height)
                }
            }
        }
        .padding()
        .onChange(of: manager.sizeOwner) {
            print ("Change \(manager.sizeOwner)")
            manager.updateSizes()
            
            
        }
    }
}

#Preview {
    ContentView(manager: Manager())
}
