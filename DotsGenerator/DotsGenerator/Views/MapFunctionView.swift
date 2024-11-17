//
//  MapFunctionView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//
import SwiftUI

struct MapFunctionView: View {
    @Binding var function: Functions
    var body: some View {
        switch function {

        case .custom(let customFunction):
            let bindingFuction = Binding(get: {customFunction}, 
                                  set: {function = .custom($0)})
            CustomFormulaView(function: bindingFuction)
        default:
            Text("\(String(describing: function))")
        }
        
    }
}
