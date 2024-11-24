//
//  FilterView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//


import SwiftUI


struct FilterView : View {
    @Binding var filter: Filter 
    var body: some View {
        
        VStack (alignment: .leading, spacing: 5) {
            Text("\(filter.name)").lineLimit(1).fontWeight(.black)
            
            switch filter {
            
            case .colorMonochrome(let color, let intensity):
                let bindingColor = Binding(get: {Color(nsColor: color)}, 
                                           set: {filter = .colorMonochrome(color: NSColor($0), intensity: intensity)}) 
                let bindingIntensity = Binding(get: {intensity}, 
                                               set: {filter = .colorMonochrome(color: color, intensity: $0)}) 
                TextField("intensity", value: bindingIntensity, format: .number)
                ColorPicker("color", selection: bindingColor, supportsOpacity: false)
                
            case .morfologyGradient(radius: let radius):
                let bindingRadius = Binding(get: {radius}, 
                                            set: {filter = .morfologyGradient(radius: $0)}) 
                TextField("radius", value: bindingRadius, format: .number)
                
            case .colorClamp(min: let min, max: let max):
                let bindingMin = Binding(get: {Color(nsColor: min)}, 
                                         set: {filter = .colorClamp(min: NSColor($0), max: max)}) 
                let bindingMax = Binding(get: {Color(nsColor: max)}, 
                                         set: {filter = .colorClamp(min: min, max: NSColor($0))}) 
                ColorPicker("min:", selection: bindingMin, supportsOpacity: false)
                ColorPicker("max:", selection: bindingMax, supportsOpacity: false)
                
            case .gaussianBlur(radius: let radius):
                let bindingRadius = Binding(get: {radius}, 
                                            set: {filter = .gaussianBlur(radius: $0)}) 
                TextField("radius", value: bindingRadius, format: .number)
                
            case .invert:
                EmptyView()
                
            case .enhancer(amount: let amount):
                let bindingAmount = Binding(get: {amount}, 
                                            set: {filter = .enhancer(amount: $0)}) 
                TextField("amount", value: bindingAmount, format: .number)
            case .gamma(power: let power):
                let bindingPower = Binding(get: {power}, 
                                            set: {filter = .gamma(power: $0)}) 
                TextField("gamma", value: bindingPower, format: .number)
            
            }
        
        }
        
    }
}
