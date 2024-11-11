//
//  CIFilters.swift
//  
//
//  Created by Łukasz Dziedzic on 10/11/2024.
//
import CoreImage
import Accelerate

public extension CIFilter  {
    static func highlightShadowAdjust(
        image: CIImage,
        radius: Double,
        shadowAmount: Double,
        highlightAmount: Double
    ) -> CIImage? {
        CIFilter(name: "CIHighlightShadowAdjust",
                 parameters: [
                    kCIInputImageKey: image,
                    "inputRadius" : NSNumber(value: radius),
                    //                        Shadow Highlight Radius.
                    //                        Default: 0
                    //                        Min: 0
                    //                        Slider Min: 0
                    //                        Slider Max: 10
                    
                    "inputShadowAmount" : NSNumber(value: shadowAmount),
                    //                        The amount of adjustment to the shadows of the image.
                    //                        Default: 0
                    //                        Min: -1
                    //                        Max: 1
                    //                        Slider Min: -1
                    //                        Slider Max: 1
                    
                    "inputHighlightAmount": NSNumber(value: highlightAmount)
                 ])?.outputImage 
        //else {fatalError("no blurred")}
 
    }
    
    static func exposureAdjust (
        image: CIImage,
        ev: Double
    ) -> CIImage? {
        
        CIFilter(name:"CIExposureAdjust",
                 parameters: [kCIInputImageKey: image,
                              "inputEV": NSNumber(value: ev)
                             ])?.outputImage 
    }
}

public extension CIImage {
    func gaussianBlur(radius: Double) -> CIImage? {
        CIFilter(name:"CIGaussianBlur",
                                     parameters: [kCIInputImageKey: self,
                                                  "inputRadius": NSNumber(value: radius)])?
            .outputImage 
    }
}
