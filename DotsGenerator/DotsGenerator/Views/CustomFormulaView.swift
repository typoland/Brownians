//
//  CustomFormulaView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 19/11/2024.
//

import SwiftUI
struct CustomFormulaView: View {
    
    @Binding var function: CustomFunction
    @State var testFormula: String = ""
    @State var image: CIImage? = nil
    @State var parserErrors : Set<Substring> = []
    @EnvironmentObject var manager: Manager
    
    let imageSize = CGSize(width: 25,
                           height: 20)
    
    func updateImage(size: CGSize) {
        Task {
            image = await function.image(size: format_3_4(size), simulate: manager.finalSize)
        }
    }
    
    func format_3_4(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: size.width*0.75)
    }
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
                
                
                if  image != nil {
                    Image(nsImage: image!.nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color.white)
                    
                }
                HStack {
                    TextField("function name", text: $function.name)
                    Button(action: {testFormula = function.formula}, label: {Image(systemName: "arrow.counterclockwise")})
                }

                TextField("formula", text: $testFormula, axis: .vertical).lineLimit(20, reservesSpace: false)
                    .onSubmit {
                        parserErrors = []
                        switch function.checkFormula(testFormula, on: manager.finalSize) {
                        case .success(let formula): 
                            function.formula = formula
                            updateImage(size: imageSize)
                        case .failure(let unresolved):
                            image = nil
                            switch unresolved {
                            case .evaluatorNotCreated:
                                parserErrors = ["evaluator not created"]
                            case .unresolved(let errors):
                                parserErrors = errors
                            case .returnsNan(let point, let size):
                                parserErrors = ["returned .nan for \(point) in \(size)"]
                            }
                            
                        }
                    }
                    .onAppear {
                        testFormula = function.formula
                        updateImage(size: imageSize)//proxy.size)
                        
                    }
                
                
                
                let t = """

    Standard math operations: 
        addition (+), 
        subtraction (-), 
        multiplication (*), 
        division (/), 
        exponentiation (^)
        factorial operator (!) 1

    Constants: 
        pi (π) and e

    1-argument functions:
        trigonometric functions: 
                sin, asin, cos, acos, tan, atan, sec, csc, ctn
        hyperbolic functions: 
                sinh, asinh, cosh, acosh, tanh, atanh
        logarithmic and 
        exponential functions: 
                log10, ln (loge), log2, exp
        others: 
                ceil, floor, round, sqrt (√), 
                cbrt (cube root), abs, and sgn

    2-argument functions: 
        atan2, hypot, pow 2

"""
                Divider().padding()
                Text ("Use **x**, **y**, **w** and **h**, result values will be clamped to `0...1`").help(t)
                   
               
                
                if !parserErrors.isEmpty {
                    Text("Error:")
                    let t = parserErrors.reduce (into:"", {$0 = $0 + "\($1)\n "})
                Text (t)
                    }
            }
        }
    }
}
