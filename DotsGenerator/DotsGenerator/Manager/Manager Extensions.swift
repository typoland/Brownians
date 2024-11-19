//
//  Manager Extensions.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 18/11/2024.
//

extension Manager {
    
    func update(from manager: Manager) {
        sizeOwner = manager.sizeOwner
        finalSize = manager.finalSize
        detailMap = manager.detailMap
        sizeMap = manager.sizeMap
        detailSize = manager.detailSize
        dotSize = manager.dotSize
        dots = []
        chaos = manager.chaos
    }
}
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
