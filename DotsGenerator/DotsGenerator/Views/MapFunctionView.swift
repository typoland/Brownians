//
//  CustomFormulaView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 19/11/2024.
//

import SwiftUI
struct MapFunctionView: View {
    
    @Binding var function: CustomFunction
    
    @EnvironmentObject var manager: Manager
    
    @State var testFormula: String = ""
    @State var testImage: CIImage? = nil
    @State var parserErrors : Set<Substring> = []
    
    
    
    let testImageSize = CGSize(width: 25,
                           height: 20)
    
    func updateImage(size: CGSize)  {
        Task {
            //Generate Image
            testImage = await function.image(
                size: format_3_4(size), 
                simulate: manager.finalSize)
            debugPrint("test image updated for: \(function.formula)")
        }
    }
    
    func format_3_4(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width, height: size.width*0.75)
    }
    
    var body: some View {
        GeometryReader {proxy in
            VStack {
//                
//                HStack {
//                    TextField("function name", text: $function.name)
//                    Button(action: {testFormula = function.formula}, label: {Image(systemName: "arrow.counterclockwise")})
//                }

                TextField("formula", text: $testFormula, axis: .vertical).lineLimit(20, reservesSpace: false)
                    .onChange(of: testFormula) {
                        
                        debugPrint("change of test formula: \(testFormula)")
                        parserErrors = []
                        switch function.checkFormula(testFormula, on: manager.finalSize) {
                        case .success(let formula): 
                            debugPrint("before Change: \(function.formula)")
                            function.formula = formula // Nothing happens
                            debugPrint("Test formula changed: \(testFormula)")
                            debugPrint("set to \(formula)")
                            debugPrint("what inside function? \(function.formula)")
                            updateImage(size: proxy.size/2)
                            
                        case .failure(let unresolved):
                            testImage = CIImage()
                            switch unresolved {
                            case .evaluatorNotCreated:
                                parserErrors = ["can't understand formula"]
                            case .unresolved(let errors):
                                parserErrors = errors
                            case .returnsNan(let point, let size):
                                parserErrors = ["returned .nan for \(point) in \(size)"]
                            }
                            
                        }
                        
                    }
                if  testImage != nil {
                    Image(nsImage: testImage!.nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color.white)
                    
                }   
#if DEBUG
                Text("Test: \(testFormula)")
                
                Text("Function: \(function.formula)")
                    
 #endif
                
                let help = """

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
                Text ("Use **x**, **y**, **w** and **h**, result values will be clamped to `0...1`")
                    .help(help)

                if !parserErrors.isEmpty {
                    Text("Error:")
                    let errorInfo = parserErrors.reduce (into:"", {$0 = $0 + "\($1)\n "})
                Text (errorInfo)
                    }
            }
        }
        .onAppear {
            testFormula = function.formula
            updateImage(size:testImageSize)
        }
    }
}
#Preview {
    @Previewable @State var f = CustomFunction()
    @ObservedObject var manager = Manager()
    
 
    MapFunctionView(function: $f) 
        .environmentObject(manager)
   
}
