import Cocoa
import SwiftUI
import PlaygroundSupport

var kidsUrl = Bundle.main.url(forResource: "kids", withExtension: "jpeg")!.resolvingSymlinksInPath()

let ciImage = CIImage(contentsOf: kidsUrl)!

let size = ciImage.extent

//let dotSize: (CGPoint) -> Double = { point in
//        let offset = CGPoint(x: size.width/2, y: size.height/2) |-| point
//        let s = cos((point.y)/size.height*Double.tau)//size.width*0.71)
//        let result = ( s*s) * 12 + 40 //(offset * sin(point.x) + offset * cos(point.y)) / 5.0 + 35.0 /// (offset+0.1/size.width+0.1)
//        return result
//    }

let chain = FiltersChain(chain: [
    {$0.morfologyGradient(radius: 8)},
    {$0.colorMonochrome(color: NSColor.white, 
                        intensity: 2)},
    {$0.colorClamp(
        min: NSColor(red:0.0, green:0.0, blue:0.0, alpha: 0.0), 
        max: NSColor(red:1.0, green:1.0, blue:1.0, alpha: 1.0))}
])
let detailMap = MapType.image(image: ciImage, filters: chain)

detailMap
let imageDotSize: (CGPoint) -> Double =  { point in
    let a = try? detailMap.value(at: point)
    let gray = 1.0 - (a ?? 0.5)
    //return gray * 10.0 + 2.0 //* 10.0 + 5.0 is nice
    return gray * 50.0 + 30.0
}
let strengthMap = MapType.image(image: ciImage, filters: nil)
let dotStrength: (CGPoint) -> Double = { point in
    let a = try? detailMap.value(at: point)
    let gray = a ?? 0.5
    return (1-gray)*0.5 + 0.1
 
}

let dots = DotGenerator(size: size.size, 
                        dotSize: imageDotSize, 
                        dotStrength: dotStrength, 
                        draw: {_,_ in}).dots



PlaygroundPage.current.setLiveView(
    TestPDFView(pdfSize: CGSize(width: size.width, height: size.height),
                content: DotTestView(dots: dots)//(res: 12)
    )
    .frame(width: size.width, height: size.height)
        
)

