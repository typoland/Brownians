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
    var body: some View {
        HStack (spacing: 20) {
            VStack {
                Text("\(manager.size)")
                HStack {
                    Text("Chaos")
                    EnterTextFiledView("0,5...0,99", 
                                       value: $manager.chaos,
                                       in: 0.4...0.99999)
                    ImageSizeView(size: $manager.size)
                }
                
                DotSizesView(refresh: $refreshPreview)
                    .frame(height: 180)
                
                
                
                HStack (alignment: .top) {
                    MapTypeView(title: "Detail size",
                                map: $manager.detailMap, 
                                size: $manager.detailSize,
                                range: 2...Double.infinity)
                    MapTypeView(title: "Dot size",
                                map: $manager.sizeMap, 
                                size: $manager.dotSize,
                                range: 0...Double.infinity)
                    
                    
                    
                }
                Spacer()
            }.onSubmit {
                refreshPreview = true
            }.frame(width: 300)
            .environmentObject(manager)
            
            /*
            VStack {
                ScrollView([.horizontal, .vertical]) {
                    DotTestView(dots: $manager.dots)
                        .frame(width: manager.size.width,
                               height: manager.size.height)
                }
                HStack {
                    Button(action: {
                        Task {
                            await manager.updateDots(in: manager.size)
                        }}, 
                           label: {Text("Start")})
                    Button(action: {
                        print ("stop")
                    }, 
                           label: {Text("How to stop?")})
                }
            }
             */
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
