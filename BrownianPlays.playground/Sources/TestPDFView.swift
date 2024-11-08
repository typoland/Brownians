//
//  SavePDF.swift
//  
//
//  Created by Łukasz Dziedzic on 06/11/2024.
//
import Foundation
import SwiftUI

public struct TestPDFView<Content: View>:  View {
    @MainActor public func savePDF(name: String, view: some View) {
        
        let dateString = Date.now.formatted(date:.abbreviated, time:.shortened)
        let url = URL(fileURLWithPath: "/Users/lukasz/Desktop/Blendy/\(name) \(dateString).pdf")
        print ("Saving to \(url)")
        let renderer = ImageRenderer(content: view.frame(width: pdfSize.width, height: pdfSize.height) ) 
        
//        renderer.render { size, renderer in
//            var mediaBox = CGRect(origin: .zero,
//                                  size: pdfSize)
//            guard let consumer = CGDataConsumer(url: url as CFURL),
//                  let pdfContext =  CGContext(consumer: consumer,
//                                              mediaBox: &mediaBox, nil)
//            else {
//                return
//            }
//            pdfContext.beginPDFPage(nil)
//            pdfContext.translateBy(x: mediaBox.size.width / 2 - size.width / 2,
//                                   y: mediaBox.size.height / 2 - size.height / 2)
//            renderer(pdfContext)
//            pdfContext.endPDFPage()
//            pdfContext.closePDF()
//        }
//        
        //*
        
        //https://www.swiftanytime.com/blog/imagerenderer-in-swiftui
        if let consumer = CGDataConsumer(url: url as CFURL), 
            let context = CGContext(consumer: consumer, mediaBox: nil, nil) {
            renderer.render { size, renderer in
                var mediaBox = CGRect(origin: .zero, size: size)
                // Drawing PDF
                
                context.beginPage(mediaBox: &mediaBox)
                renderer(context)
                context.endPDFPage()
                context.closePDF()
                // Updating the PDF URL
                //print(NSHomeDirectory())
            }
        }
         //*/
        print ("saved to \(url)")
    } 
    
    public init(pdfSize: CGSize = CGSize(width: 1000, height: 1000), content: Content ) {
        self.content = content
        self.pdfSize = pdfSize
    }
    
    @ViewBuilder let content: Content
    var pdfSize: CGSize
    
    public var body: some View {
        VStack {
            content
            Button (action: {
                savePDF(name: "new", view: content)
            }) {
                Text("save PDF")
            }
        }
        
    }
} 
