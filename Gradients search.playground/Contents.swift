import Cocoa
import SwiftUI
import PlaygroundSupport

var greeting = "Hello, playground"

let z = Path {path in
    path.addRect(CGRect(x: 0, y: 0, width: 200, height: 200))
}

struct aloha: View {
    let stops = [
        Gradient.Stop(color: .blue, location: 0),
        Gradient.Stop(color: .green, location: 0.1),
        Gradient.Stop(color: .orange, location: 0.5),
        Gradient.Stop(color: .pink, location: 1),
    ]
    var body: some View {
        VStack {
            z.fill(.radialGradient(
                Gradient(stops: stops),
                                   center: .center,
                                   startRadius: 10,
                                   endRadius: 100))
            .frame(width: 200, height: 200)
            
            z.fill(.linearGradient(
                Gradient(stops: stops), 
                startPoint: UnitPoint(x: 0.0, y: 0.0), 
                endPoint: UnitPoint(x: 0.99, y: 0.99)))
            .frame(width: 200, height: 200)
            
            z.fill(.angularGradient(
                Gradient(stops: stops), 
                center: .center, 
                startAngle: Angle(degrees: 0), 
                endAngle: Angle(degrees: 90)))
            .frame(width: 200, height: 200)
            
            z.fill(.ellipticalGradient(
                stops: stops, 
                center: .center,
                startRadiusFraction: 0.05, 
                endRadiusFraction: 0.5))
            .frame(width: 200, height: 200)
        }
    }
}

PlaygroundPage.current.setLiveView(
    aloha()
)
