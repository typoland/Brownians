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
    
    @AppStorage("resultsFolder") var resultsFolderPath: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("results")
    
    @ViewBuilder
    var finalView : some View {
        let size = manager.finalSize * manager.finalScale
        GenerateDotsView(refresh: $refreshDrawing,
                         savePDF: $savePDF,
                         saveFolderURL: resultsFolderPath)
        .environmentObject(manager)
        .frame(width:size.width, 
               height: size.height)
        
    }
    
    var pathNiceString: String {
        let s: [String] = Array<String> ( resultsFolderPath.pathComponents[1..<resultsFolderPath.pathComponents.count])
        return s.reduce("") { $0 + "/" + $1 }
    }
    
    
    let largeFont = NSFont.systemFont(ofSize: 60)
    var configuration = NSImage.SymbolConfiguration(textStyle: .body, scale: .large)
    
    
    var body: some View {
        HStack (spacing: 20) {
            
            ManagerSetupView()
                .environmentObject(manager)
                .frame(width: 350) 
            
            VStack {
                ScrollView([.horizontal, .vertical]) {
                    let size = manager.finalSize
                    finalView
                        .frame(width: size.width * manager.finalScale, 
                               height: size.height * manager.finalScale)
                }
            }
        }
        .padding()
        .onChange(of: manager.sizeOwner) {
            print ("Change \(manager.sizeOwner)")
            manager.updateSizes()
            
            
        }
        .toolbar {
            
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
                savePDF = true
            }, label: {Text("Save to \(pathNiceString)")})
            
        }
        .environmentObject(manager)
        .focusedValue(\.savePath, $choosePath)
        .focusedValue(\.saveFile, $savePDF)
        .fileImporter(isPresented: $choosePath, 
                      allowedContentTypes: [.folder]) { result in
            if case .success(let url) = result {
                resultsFolderPath = url
                debugPrint("new Path:",resultsFolderPath)
            }
            print ("try to laoad")}
        
    }
}

#Preview {
    ContentView(manager: Manager())
}
