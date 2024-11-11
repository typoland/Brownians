import Cocoa

var greeting = "Hello, playground"
for i in 0...100 {
    let n = Double(i) / 100.0
    let p = 1-((1.0-n)*(1.0-n)*(1.0-n))
print (p)    
}
