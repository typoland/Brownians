//
//  ContentView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import Foundation
import SwiftUI

struct ContentView: View {
    //var densityMap: CIImage? = Defaults.ciImage
    @ObservedObject var manager = Manager()
    var body: some View {
        HStack (spacing: 20) {
            MapTypeView(map: $manager.detailMap).frame(width: 200)
            MapTypeView(map: $manager.strengthMap).frame(width: 200)
            Spacer()
            VStack {
                DotTestView(manager: manager)
                    .frame(width: manager.size.width,
                           height: manager.size.height)
                Button(action: {manager.updateDots()}, 
                       label: {Text("updateDots")})
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
