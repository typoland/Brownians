import Cocoa
import SwiftUI
import PlaygroundSupport

var greeting = "Hello, playground"

let z = Path {path in
    path.addRect(CGRect(x: 0, y: 0, width: 300, height: 200))
}

struct aloha: View {
    let stops = [
        Gradient.Stop(color: .blue, location: 0.0),
        Gradient.Stop(color: .green, location: 0.45),
        Gradient.Stop(color: .orange, location: 0.5),
        Gradient.Stop(color: .pink, location: 0.8),
        Gradient.Stop(color: .blue, location: 1),
    ]
    let center: UnitPoint = UnitPoint(x: 0.25, y: 0.25)
    var body: some View {
        VStack {
            Text("radial")
            z.fill(.radialGradient(
                Gradient(stops: stops),
                                   center: center,
                                   startRadius: 100,
                                   endRadius: 200))
            .frame(width: 300, height: 200)
            Text("linear")
            z.fill(.linearGradient(
                Gradient(stops: stops), 
                startPoint: center, 
                endPoint: UnitPoint(x: 0.99, y: 0.99)))
            .frame(width: 300, height: 200)
            Text("angular")
            z.fill(.angularGradient(
                Gradient(stops: stops), 
                center: center, 
                startAngle: Angle(degrees: 0), 
                endAngle: Angle(degrees: 90)))
            .frame(width: 300, height: 200)
            Text("eliptical")
            z.fill(.ellipticalGradient(
                stops: stops, 
                center: center,
                startRadiusFraction: 0.0, 
                endRadiusFraction: 1))
            .frame(width: 300, height: 200)
            Text("conic")
            z.fill(.conicGradient(Gradient(stops: stops),
                   center: center, 
                   angle: Angle(degrees: 0))
                )
            .frame(width: 300, height: 200)
            
            
        }
    }
}

PlaygroundPage.current.setLiveView(
    aloha()
)
