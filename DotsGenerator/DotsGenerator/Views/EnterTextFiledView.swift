//
//  EnterTextFiledView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

struct EnterTextFiledView<T>: View
where T : FloatingPoint {
    var titleKey: LocalizedStringKey
    @Binding var value: T
    var range:ClosedRange<T>
    @State private var local: T
    @FocusState private var focused: Bool
    var formatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 3
        return nf
    }
    func checkRangeAndAssign() {
        if !range.contains(local) {
            local = value
        } else {
            value = local
        }
    }
    init(_ titleKey: LocalizedStringKey, value: Binding<T>, in range:ClosedRange<T>
    ) {
        self.titleKey = titleKey
        self._value = value
        self.local = value.wrappedValue
        self.range = range
    }
    
    var body: some View {
        TextField(titleKey, value: $local, formatter: formatter)
            .onSubmit {
                checkRangeAndAssign()
            }
            .onAppear {
                local = value
            }.focused ($focused, equals: true)
            .onChange(of: focused) {
                if !focused {checkRangeAndAssign()}
            }
            .onChange(of: value) {
                print ("CHANGED VALUE")
                local = value
            }
    }
}

#Preview {
    @Previewable @State var test = 0.2
    EnterTextFiledView("", value: $test, in: 0...10)
}
