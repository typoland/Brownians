//
//  NSColor.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 20/11/2024.
//
import AppKit
import SwiftUI

extension Color {
    static func tryIndex(_ index: Int) -> Color {
        let buka = index % 128

        let r = (buka & 0b11111) 
        let g = (buka & 0b111110) >> 1
        let b = (buka & 0b1111100) >> 2
        
        return Color(nsColor : NSColor(red: CGFloat(r)/32.0, 
                       green: CGFloat(g)/32, 
                       blue: CGFloat(b)/32, 
                       alpha: 1))
    }
}
