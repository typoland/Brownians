//
//  Manager Extensions.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 18/11/2024.
//


import AppKit
import SwiftUI
extension Manager: @preconcurrency Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .json) { manager in
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(manager)
        } importing: { data in
            let decoder = JSONDecoder()
            return try decoder.decode(Manager.self, from: data)
        }
        
        DataRepresentation(exportedContentType: .json) { manager in
            let encoder = JSONEncoder()
            
            return try encoder.encode(manager)
        }
    }
    
}

extension Manager: @preconcurrency CustomStringConvertible {
    var description: String {"""
Manager chaos: \(chaos)
detail Map:    \(detailMap)
detail Size:   \(detailSize)
size Map:      \(sizeMap)
dot size:      \(dotSize)
size owner:    \(sizeOwner) \(finalSize)
"""
    }
}
