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
                Text("\(manager.finalSize)")
                HStack {
                    Text("Chaos")
                    EnterTextFiledView("0,5...0,99", 
                                       value: $manager.chaos,
                                       in: 0.4...0.99999)
                    ImageSizeView(size: $manager.finalSize)
                }
                
//                var detailMap: (CGSize) -> MapType  = { size in
//                    return .function(
//                        Functions.verticalBlend,
//                        dotSize: DotSize(maxSize: 10, minSize: 6))
//                    
//                }
//                var dotSizeMap: (CGSize) -> MapType = { size in
//                    return .function(
//                        Functions.horizontalBlend,
//                        dotSize: DotSize(maxSize: 10, minSize: 6))
//                    
//                }
                
                DotSizesView(refresh: $refreshPreview)
                    .frame(height: 500)
                
                
                
                HStack (alignment: .top) {
                    MapTypeView(title: "Detail size",
                                map: $manager.detailMap, 
                                dotSize: $manager.detailSize,
                                range: 2...Double.infinity)
                    MapTypeView(title: "Dot size",
                                map: $manager.sizeMap, 
                                dotSize: $manager.dotSize,
                                range: 0...Double.infinity)
                    
                    
                    
                }
                Spacer()
            }.onSubmit {
                refreshPreview = true
            }.frame(width: 500)
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
