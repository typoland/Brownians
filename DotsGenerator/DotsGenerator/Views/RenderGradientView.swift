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
        let style = data.style(with: stops)
        ZStack {
            
            switch style {
            case is LinearGradient:
                Rectangle()
                    .fill(style as! LinearGradient)
                
            case is EllipticalGradient:
                Rectangle()
                    .fill(style as! EllipticalGradient)
            case is AngularGradient:
                Rectangle()
                    .fill(style as! AngularGradient)
            default:
                Text("no gradient")
            }
            
          
           
        }.frame(width: size.width, height: size.height)
    }
}
