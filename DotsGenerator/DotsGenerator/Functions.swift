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
//https://github.com/bradhowes/swift-math-parser?tab=readme-ov-file
struct CustomFunction {
    enum PareserErrors: Error {
        case evaluatorNotCreated
        case unresolved(Set<Substring>)
        case returnsNan(CGPoint, CGSize)
        
    }
    var name: String = "new" 
    var formula: String = "sin(x/(w/pi/12))/2 + 0.5"
    func parser(point: CGPoint, size:CGSize) ->  MathParser {
        let variables = ["x": Double(point.x),
                         "y": Double(point.y),
                         "w": Double(size.width),
                         "h": Double(size.height)]
        
        return MathParser(variables: variables.producer)//, 
        //                                variableDict: nil, 
        //                                unaryFunctions: nil, 
        //                                unaryFunctionDict: nil, 
        //                                binaryFunctions: nil, 
        //                                binaryFunctionDict: nil, 
        //   enableImpliedMultiplication: true)
    }  
    func parse() -> (CGPoint, CGSize) -> Double {
        { point, size in
            let evaluator = parser(point: point, size: size).parse(formula)
            return evaluator?.value.clamped(to: 0...1) ?? 0.0  
        }      
    }
    
    func checkFormula(_ formula: String, on size: CGSize) -> Result<String, PareserErrors> {
        let w = size.width
        let h = size.height
        
        var uresolved = Set<Substring>()
        let testPoints = [CGPoint(x: 0,y: 0),
                          CGPoint(x: w,y: 0),
                          CGPoint(x: 0,y: h),
                          CGPoint(x: w,y: w),
                          CGPoint(x: w/2,y: h/2),]
        for point in testPoints {
            let evaluator = parser(point: point, size: size).parse(formula)
            if let evaluator  {
                uresolved.formUnion(evaluator.unresolved.binaryFunctions)
                uresolved.formUnion(evaluator.unresolved.unaryFunctions)
                uresolved.formUnion(evaluator.unresolved.variables)
            } else {
                return .failure(.evaluatorNotCreated)
            }
            if evaluator?.value == Double.nan {
                return .failure(.returnsNan(point, size))
            }
        }
        //if uresolved.isEmpty {
        return .success(formula)
        // }
    
        //return .failure(.unresolved(uresolved))
    }
    func image(size: CGSize, simulate: CGSize) async -> CIImage {
        let width = Int(size.width)
        let height = Int(size.height)
        let xProp = simulate.width / size.width  
        let yProp = simulate.height / size.height
        
        var buffer : [UInt8] = []
        for row in 0..<height {
            for column in 0..<width {
                let val = parse()(CGPoint(x: CGFloat(column) * yProp, 
                         y: CGFloat(height-row) * xProp), 
                 simulate) 
                * 255.0
                
                buffer.append(val.isNaN ? 0 : UInt8(clamping: Int(Double(val))))
            }
        }
        let data = Data(bytes: &buffer, count: width * height )
        let image = CIImage(bitmapData: data, 
                            bytesPerRow:  width, 
                            size: CGSize(width: width, height: height), 
                            format: .A8, 
                            colorSpace: nil)
        return image
    }
}
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

                TextField("formula", text: $testFormula, axis: .vertical)
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
Use **x**, **y**, **w** and **h**, result values will be clamped to `0...1`
Standard math operations: addition (+), subtraction (-), multiplication (*), division (/), and exponentiation (^)
The factorial operator (!) 1
Constants: pi (π) and e
1-argument functions:
trigonometric functions: sin, asin, cos, acos, tan, atan, sec, csc, ctn
hyperbolic functions: sinh, asinh, cosh, acosh, tanh, atanh
logarithmic and exponential functions: log10, ln (loge), log2, exp
others: ceil, floor, round, sqrt (√), cbrt (cube root), abs, and sgn
2-argument functions: atan2, hypot, pow 2
"""
                Text (t).controlSize(.mini)
                Divider().padding()
                if !parserErrors.isEmpty {
                    Text("Error:")
                    let t = parserErrors.reduce (into:"", {$0 = $0 + "\($1)\n "})
                Text (t)
                    }
            }
        }
    }
}
