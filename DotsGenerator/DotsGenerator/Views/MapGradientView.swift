//
//  MapGradientView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 22/11/2024.
//

import SwiftUI

struct MapGradientView: View {
    @Binding var type: MapType.GradientType
    @Binding var stops: [GradientStop]
    @Binding var data: any GradientData
    //@State var choosen: MapType.GradientType = .linear
    //@Binding var data: GradientData
    
    var body: some View {
        
        
        
        VStack {
            
                Picker("gradient type", selection: $type) { 
                    let _ = debugPrint("Picker selection", type)
                    ForEach(MapType.GradientType.allCases, id:\.stringValue) { type in
                        Text("\(type.stringValue.capitalized)").tag(type)
                        let _ = debugPrint("    tag:",type)
                    }
                }                
                
                switch type {
                case .angular:
                    let dataBinding = Binding(
                        get: {data as! AngularGradientData}, 
                        set: {data = $0})
                    AngularGradientDataView(
                        angularGradientData: dataBinding, 
                        stops: $stops)
                    
                    
                case .eliptical:
                    let dataBinding = Binding(
                        get: {data as! ElipticalGradientData}, 
                        set: {data = $0})
                    EllipticalGradientDataView(
                        ellepticalGradientData: dataBinding, 
                        stops: $stops)
                    
                case .linear:
                    let dataBinding = Binding(
                        get: {data as! LinearGradientData}, 
                        set: {data = $0 })
//                    
                    
                    LinearGradientDataView(
                        linearGradientData: dataBinding, 
                        stops: $stops)
                }
                
        
            //Text("choosen \(choosen)")
        }
    }
    
    //Rectangle().fill(type)
}


//#Preview {
//    MapGradientView()
//}
