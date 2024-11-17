//
//  Functions.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 15/11/2024.
//
import Foundation
typealias DotFunction = (CGPoint) -> Double

enum Functions {
    case horizontalBlend
    case verticalBlend
    case custom(CustomFunction)
    
    func inSize(_ size: CGSize) -> DotFunction {
        switch self {
        case .verticalBlend:
            return { (size.height-$0.y)/size.height }
        case .horizontalBlend:
            return { (size.width-$0.x)/size.width }
        case .custom(let custom) :
            return { custom.parse()($0, size) }
        }
    }
}
import MathParser

struct CustomFunction {
    var name: String = "new" 
    var formula: String = "cos(x / width) * sin(y / height)"
       
    func parse() -> (CGPoint, CGSize) -> Double {
        { point, size in
            let variables = ["x": Double(point.x),
                             "y": Double(point.y),
                             "width": Double(size.width),
                             "height": Double(size.height)]
            //        let funcs: [String: (Double, Double, Double, Double)->Double] = [
            //            "simple" : {cos($0 / $2) * sin($1 / $3)}
            //        ]
            let parser = MathParser(variables: variables.producer)//, 
            //                                variableDict: nil, 
            //                                unaryFunctions: nil, 
            //                                unaryFunctionDict: nil, 
            //                                binaryFunctions: nil, 
            //                                binaryFunctionDict: nil, 
            //                                enableImpliedMultiplication: true)
            
            
            
            let evaluator = parser.parse(formula)
            return evaluator?.value ?? Double.nan  }      
    }
}
import SwiftUI
struct CustomFormulaView: View {
    @Binding var function: CustomFunction
    
    var body: some View {
        TextField("function name", text: $function.name)
        TextField("formula", text: $function.formula )
    }
}
