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
    var body: some View {
        HStack (spacing: 20) {
            VStack {
                Text("\(manager.size)")
                HStack {
                    Text("Chaos")
                    EnterTextFiledView("0,5...0,99", value: $manager.chaos)
                    ImageSizeView(size: $manager.size)
                }
                DotSizesView(manager: manager)
                HStack {
                MapTypeView(map: $manager.detailMap).frame(width: 200)
                MapTypeView(map: $manager.sizeMap).frame(width: 200)
                }
            }.frame(width: 450)
            .environmentObject(manager)
            Spacer()
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
