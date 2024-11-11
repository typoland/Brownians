//
//  DotGeneratorSetups.swift
//  
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
/*
public extension DotGenerator {
    static func photo(url: URL) throws -> DotGenerator? {
        guard let ciImage = CIImage(contentsOf: url) else {throw Errors.noURL(url)}
        let size = ciImage.extent
        guard let detail = ciImage
            .detailMap(radius: 10.0) else {throw Errors.failedOnCIFilter}
        
        DotGenerator(
            dotSize: <#T##(CGPoint) -> Double#>, 
            dotStrength: <#T##(CGPoint) -> Double#>, 
            draw: <#T##(CGContext, CGSize) -> Void#>) {
                
            }
    }
}
*/
