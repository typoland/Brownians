//
//  MapFunctionView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//
import SwiftUI

struct MapFunctionView: View {
    var function: Functions
    var body: some View {
        Text("\(String(describing: function))")
    }
}
