import Cocoa
import SwiftUI
import PlaygroundSupport

enum MapTypeNames: String, CaseIterable {
    case number = "Number"
    case image = "Image"
    case function = "Function"
}

MapTypeNames.allCases.forEach({print ("forEach: \($0.rawValue)")})
struct Test: View {
    @State var name: String = ""
    var body: some View {
        Picker(selection: $name, 
               content: {
            ForEach(MapTypeNames.allCases, id:\.rawValue) {raw in
                let _ = print(raw)
                Text("ForEach \(raw)").tag(raw)
            }
        }
               }) {Text("So what?")}
    }
    
    PlaygroundPage.current.setLiveView(
        Test()    
    )
