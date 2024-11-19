//
//  SizesView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 19/11/2024.
//

import SwiftUI

struct SizesView: View {
    @Binding var dotSize: DotSize
    var range: ClosedRange<Double>
    var body: some View {
        VStack {
            HStack {
                Text("min:")
                EnterTextFiledView("minimum", 
                                   value: $dotSize.minSize,
                                   in: range)
            }
            HStack {
                Text("max:")
                EnterTextFiledView("maximum", 
                                   value: $dotSize.maxSize,
                                   in: range)
            }
        }
    }
}
