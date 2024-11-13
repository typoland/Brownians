//
//  FiltersChain.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage
import AppKit

public struct FiltersChain: Equatable {
    
    nonisolated public static func == (lhs: FiltersChain, rhs: FiltersChain) -> Bool {
        lhs.chain == rhs.chain
    }
    
    enum Errors: Error {
        case filterFailed
    }
    
    var chain: [Filters]
    func result(source: CIImage) throws -> CIImage {
        var result: CIImage? = source
        for filter in chain {
            result = filter.filter(image: result!)
            if result == nil {
                throw Errors.filterFailed
            }
        }
        return result!
    }
}

extension FiltersChain: CustomStringConvertible {
    public var description: String {
        "\(chain.count) filters"
    }
    
    
}
