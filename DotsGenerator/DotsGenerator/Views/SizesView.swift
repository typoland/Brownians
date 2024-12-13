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
                EnterTextFiledView(titleKey: "minimum", 
                                   value: $dotSize.minSize,
                                   range: range)
            }
            HStack {
                Text("max:")
                EnterTextFiledView(titleKey: "maximum", 
                                   value: $dotSize.maxSize,
                                   range: range)
            }
        }
    }
}
#Preview {
    @Previewable @State var dotSize = DotSize(minSize: 2, maxSize: 20)
    SizesView(dotSize: $dotSize, range: 0...100)
}
