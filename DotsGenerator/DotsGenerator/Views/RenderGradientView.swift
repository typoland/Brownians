//
//  GradientView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 22/11/2024.
//

import SwiftUI

struct RenderGradientView: View {
    var size: CGSize
    var stops: [GradientStop]
    var data:  any GradientData


    var body: some View {      
        let gradient = data.gradient(from: stops)
        ZStack {
            switch data {
            case is LinearGradientData:
                let linear = data as! LinearGradientData
                Rectangle()
                    .fill(.linearGradient(
                        gradient.colorSpace(.device), 
                        startPoint: linear.start, 
                        endPoint: linear.end) )
            case is ElipticalGradientData:
                let eliptical = data as! ElipticalGradientData
                Rectangle()
                    .fill(.ellipticalGradient(
                        gradient.colorSpace(.device),
                        center: eliptical.center,
                        startRadiusFraction: eliptical.startRadiusFraction,
                        endRadiusFraction: eliptical.endRadiusFraction
                    ))
                       
            case is AngularGradientData:
                let angular = data as! AngularGradientData      
                Rectangle()
                    .fill(.angularGradient(
                        gradient.colorSpace(.device), 
                        center: angular.center, 
                        startAngle: Angle(degrees: angular.startAngle), 
                        endAngle: Angle(degrees: angular.endAngle)
                    ))
            default:
                Text("no gradient")
            }
            
          
           
        }.grayscale(1)
          
        .frame(width: size.width, height: size.height)
    }
}
