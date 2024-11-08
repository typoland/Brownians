import Cocoa
import SwiftUI
import PlaygroundSupport

var orbits = AnglesRanges()
//orbits.add(from:Double(50).radians, to: Double(-30).radians)
let steps = 180.0
for i in 0..<Int(steps) {
    let step = Double.tau / steps
    orbits.add(from: step*Double(i), to: step*Double(i)+1.0.radians)
}

let view =  orbits.view(color: .blue)


PlaygroundPage.current.setLiveView(
    TestPDFView(pdfSize: CGSize(width: 800, height:800),
                content: DotTestView()//(res: 12)
    )
    .frame(width: 800, height: 800)
        
)
