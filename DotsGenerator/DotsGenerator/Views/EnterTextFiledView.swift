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
    @State private var local: T
    @FocusState private var focused: Bool
    var formatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 3
        return nf
    }
    
    init(_ titleKey: LocalizedStringKey, value: Binding<T>) {
        self.titleKey = titleKey
        self._value = value
        self.local = value.wrappedValue
    }
    var body: some View {
        TextField(titleKey, value: $local, formatter: formatter)
            .onSubmit {
                value = local
            }
            .onAppear {
                local = value
            }.focused ($focused, equals: true)
            .onChange(of: focused) {
                if !focused {value = local}
            }
            
    }
}

#Preview {
    @Previewable @State var test = 0.2
    EnterTextFiledView("", value: $test)
}
