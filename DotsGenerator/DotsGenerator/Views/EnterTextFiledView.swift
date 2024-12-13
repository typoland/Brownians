//
//  EnterTextFiledView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

struct EnterTextFiledView: View
{
    var titleKey: LocalizedStringKey
    @Binding var value: Double
    var range: ClosedRange<Double>
    
    @State private var local: Double
    @FocusState private var focused: Bool
    
    
    func formatter(_ range: ClosedRange<Double>) -> NumberFormatter {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 3
        nf.minimum = (range.lowerBound) as NSNumber
        nf.maximum = (range.upperBound) as NSNumber
        return nf
    }
    
    init(titleKey: LocalizedStringKey, 
         value: Binding<Double>, 
         range: ClosedRange<Double>
    ) {
        self.titleKey = titleKey
        self._value = value
        self.local = value.wrappedValue
        self.range = range
    }
    
    var body: some View {
        TextField(titleKey, 
                  value: $local, 
                  formatter: formatter(range))
            .onAppear {
                local = value
            }
            .focused ($focused, equals: true)
            .onChange(of: focused) {
                if !focused {value = local}
            }
            .onSubmit {
                value = local
                debugPrint("EnterTextFiled submit -> \(value)")
            }
    }
}

struct EnterTextFiledViewB: View 
{
    var titleKey: LocalizedStringKey
    @Binding var value: Double
    var range: ClosedRange<Double>
    func formatter(_ range: ClosedRange<Double>) -> NumberFormatter {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 3
        nf.minimum = (range.lowerBound) as NSNumber
        nf.maximum = (range.upperBound) as NSNumber
        return nf
    }
    var body: some View { 
        TextField(titleKey, value: $value, formatter: NumberFormatter()) 
    }
}

#Preview {
    @Previewable @State var test = 0.2
    EnterTextFiledView(titleKey: "", value: $test, range: 0...10)
}
