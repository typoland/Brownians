//
//  MapValueView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI
struct MapValueView: View {
    @Binding var value: CGFloat
    var body: some View {
        TextField("value:", value: $value, formatter: NumberFormatter())
    }
}
