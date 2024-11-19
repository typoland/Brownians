//
//  DesignDotView+Extension.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 16/11/2024.
//

import AppKit
import SwiftUI

extension DotView {
    @MainActor public func savePDF(url: URL, name: String) {
        
        let dateString = Date.now.formatted(date:.abbreviated, time: .complete)
        let pdfUrl = url.appending(component: "\(name) \(dateString).pdf")

        print ("Saving to \(pdfUrl)")
        let renderer = ImageRenderer(content: canvas.frame(width: size.width, 
                                                           height: size.height) ) 

        
        //https://www.swiftanytime.com/blog/imagerenderer-in-swiftui
        if let consumer = CGDataConsumer(url: pdfUrl as CFURL), 
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
       
        print ("saved to \(pdfUrl)")
    } 
}
