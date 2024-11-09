import Cocoa
import SwiftUI
import PlaygroundSupport
import CoreImage
import Accelerate


//let imageResource = ImageResource(name: "Yellow.png", bundle: Bundle.main)
//let nsImage = NSImage(resource: imageResource)
//let cgImage = nsImage
//    .cgImage(forProposedRect: nil,//&rect, 
//             context: nil, 
//             hints:  nil)! //[NSImageRep.HintKey : Any]?
//print (CIFilter.filterNames(inCategories: []))
var url = Bundle.main.url(forResource: "Yellow", withExtension: "png")!.resolvingSymlinksInPath()
url


let ciImage = CIImage(contentsOf: url)!


let cropped = ciImage.cropped(to: CGRect(x: -10, y: -10, width: 20, height: 20))

print (cropped.detailLevel)
print (cropped.averageColor)


let view : some View = {
    VStack {
        Text ("hello")
        Image(nsImage: cropped.nsImage)
        
       
    }
}()



PlaygroundPage.current.setLiveView(
    view.frame(width: 800, height: 800)
    
)
