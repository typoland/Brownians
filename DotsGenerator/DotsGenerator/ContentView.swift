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
    @State var densityMap = Defaults.map
    var body: some View {
        VStack {
            MapTypeView(map: $densityMap).frame(width: 250)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
