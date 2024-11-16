//
//  MapValueView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI
struct MapValueView<T>: View 
where T: FloatingPoint {
    @Binding var value: T
    var body: some View {
        EnterTextFiledView("value:", value: $value, in: 0...1)
    }
}
