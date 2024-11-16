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
    
    
    
    @ViewBuilder
    var finalView : some View {
        let size = manager.finalSize
        GenerateDotsView(refresh: $refreshDrawing, 
                         savePDF: $savePDF, 
                         manager: manager)
                .frame(width:size.width, 
                       height: size.height)
     
    }
    
    var body: some View {
        HStack (spacing: 20) {
            VStack {
                
                
                GenerateDotsView(refresh: $refreshPreview, 
                                 savePDF: .constant(false), 
                                 manager: manager)
                    .frame(height: 200)
                
                
                
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
                    Text("\(manager.finalSize)")
                    Text("Chaos")
                    EnterTextFiledView("0,5...0,99", 
                                       value: $manager.chaos,
                                       in: 0.4...1)
                    ImageSizeView(size: $manager.finalSize)
                }.environmentObject(manager)
                
                ScrollView([.horizontal, .vertical]) {
                    let size = manager.finalSize
                    finalView
                        .environmentObject(manager) 
                        .frame(width:size.width, 
                               height: size.height)
                }
                HStack {
                    Button(action: {
                        refreshDrawing.toggle()
                    }, 
                           label: {Text("\(refreshDrawing ? "⏸️ Stop" : " ▶️ Start") Render")})
                    .buttonStyle( .borderless )
                    .controlSize(.extraLarge)
                    Button (action: {
                        savePDF = true
                    }, label: {Text("save PDF")})
                
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
    ContentView()
}
