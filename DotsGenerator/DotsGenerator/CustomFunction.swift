//
//  Functions.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 15/11/2024.
//
import Foundation
import CoreImage
import MathParser
//https://github.com/bradhowes/swift-math-parser?tab=readme-ov-file


typealias DotFunction = (CGPoint) -> Double
struct CustomFunction: Codable, Hashable {
    
    enum PareserErrors: Error {
        case evaluatorNotCreated
        case unresolved(Set<Substring>)
        case returnsNan(CGPoint, CGSize)
    }
    
    var name: String = "new" 
    var formula: String = "0.5"
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
    
    func inSize(_ size: CGSize) -> DotFunction {
        return { parse()($0, size) }
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
        return .success(formula)
    }
    
    func image(size: CGSize, simulate: CGSize) async -> CIImage {
        //fit width, keep proportions
        let width = Int(size.width)
        let prop = simulate.width / size.width  
        let height = Int(simulate.height / prop)
        
        var buffer : [UInt8] = []
        for row in 0..<height {
            for column in 0..<width {
                let val = 255.0 - (parse()(CGPoint(x: CGFloat(column) * prop, 
                         y: CGFloat(height-row) * prop), 
                 simulate) 
                * 255.0)
                
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
