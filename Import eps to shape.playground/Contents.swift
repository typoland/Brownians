import SwiftUI
import PlaygroundSupport
import AppKit
import PDFKit

var greeting = "Hello, playground"
func convert(pdf: PDFDocument) {
    if let page = pdf.page(at: 0) {
        let size = CGSize(width: 10, height: 10) //what size
       
        
        
    }
}


struct PDFKitView:   NSViewRepresentable {
    let doc: PDFDocument // new variable to get the URL of the document
    
    func makeNSView(context: NSViewRepresentableContext<PDFKitView>) -> PDFView {
        // Creating a new PDFVIew and adding a document to it
        let pdfView = PDFView()
        pdfView.document = doc
        return pdfView
    }
    
    func updateNSView(_ uiView: PDFView, context: NSViewRepresentableContext<PDFKitView>) {
        // we will leave this empty as we don't need to update the PDF
    }
}

struct Example : View {
    @State var openDoc = false
    @State var pdf: PDFDocument? = nil
    @State var cgPdf: CGPDFDocument? = nil
    @State var pdfData: Data? = nil
    
    func boo(_ pdf:CGPDFDocument) {
        let z = pdf.page(at: 0)
        z.
    }
    
    var body: some View {
        VStack {
            Button(action: {openDoc = true}) {
                Text ("Open PDF")
            }        
            if let pdf {
//                PDFKitView(doc: pdf)
//                    .scaledToFill()
                    //.frame(width: 1000, height: 1000)
               
            }
            Text("Hejo")
        }
            .fileImporter(isPresented: $openDoc, allowedContentTypes: [.pdf]) {result in
                switch result {
                   
                case .success(let file):
                    print (file)
                    pdf = PDFDocument(url: file) 
                    pdfData = try? Data(contentsOf: file)
                    cgPdf = CGPDFDocument(file as CFURL)
                    print (cgPdf)
                    
                    
                case .failure(let error):
                    print (error)
                } 
            }
    }
}


PlaygroundPage.current.setLiveView(Example())
