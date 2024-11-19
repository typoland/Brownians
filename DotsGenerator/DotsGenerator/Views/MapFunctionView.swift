//
//  MapFunctionView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//
import SwiftUI

struct MapFunctionView: View {
    @Binding var function: CustomFunction
    var body: some View {
        CustomFormulaView(function: $function)
    }
}
