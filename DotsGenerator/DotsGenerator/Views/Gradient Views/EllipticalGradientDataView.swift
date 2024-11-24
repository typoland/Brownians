//
//  EllipticalGradientDataView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 24/11/2024.
//

import SwiftUI

struct EllipticalGradientDataView: View {
    @Binding var ellepticalGradientData: ElipticalGradientData
    @Binding var stops: [GradientStop]
    @EnvironmentObject var manager: Manager
    var body: some View {
        GeometryReader {proxy in
            VStack {
                let prop = manager.finalSize.width/manager.finalSize.height
                let conrrolViewSize = CGSize(width: proxy.size.width, height: proxy.size.height / prop)
                ZStack {
                    RenderGradientView(size: conrrolViewSize, 
                                       stops: stops, 
                                       data: ellepticalGradientData)
                } 
            }
            StopsView (stops: $stops)
        }
    }
}


#Preview {
    @Previewable @State var data = ElipticalGradientData()
    @Previewable @State var stops: [GradientStop] = [
        GradientStop(color: .awhite, location: 0),
        GradientStop(color: .ablack, location: 0.33),
        GradientStop(color: .awhite, location: 0.66),
        GradientStop(color: .ablack, location: 1),
    ]
    EllipticalGradientDataView(
        ellepticalGradientData: $data, 
        stops: $stops)
    .environmentObject(Manager())
}
