import Cocoa
import SwiftUI
import PlaygroundSupport
import CoreImage
import Accelerate


var url = Bundle.main.url(forResource: "kids", withExtension: "jpeg")!.resolvingSymlinksInPath()
url


let ciImage = CIImage(contentsOf: url)!
let size = ciImage.extent
//let cropped = ciImage.cropped(to: CGRect(x: -10.5, y: -10.3, width: 20, height: 20))

//print (cropped.detailLevel)
//print (cropped.averageColor)
let image1 = CIFilter.highlightShadowAdjust(
    image: ciImage, 
    radius: 15, 
    shadowAmount: 1, 
    highlightAmount: 1)

let image = CIFilter.highlightShadowAdjust(
    image: image1!, 
    radius: 15, 
    shadowAmount: 1, 
    highlightAmount: 1)


CIFilter(name:"CIColorMonochrome")

print (ciImage.pixelColor(at: CGPoint(x:10, y:20)))
//
let i = image!.detailMap//?.nsImage
let j = CIFilter.exposureAdjust(image: i!, ev: 1.0)
//print (i)
let view : some View = {
    VStack {
        Text ("hello")
        Image(nsImage: j?.nsImage ?? ciImage.nsImage)
    }
}()



PlaygroundPage.current.setLiveView(
    view.frame(width: size.width, height: size.height)
    
)
