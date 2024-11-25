//
//  SizeView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 25/11/2024.
//
import SwiftUI

struct CGSizeView: View {
    @Binding var size: CGSize
    var range: ClosedRange<CGFloat>
    var body: some View {
        
        HStack {
            Text ("width" )
            Slider(value: $size.width, in: range)
        }
        HStack {
            Text ("height" )
            Slider(value: $size.height, in: range)
        }
    }
}
