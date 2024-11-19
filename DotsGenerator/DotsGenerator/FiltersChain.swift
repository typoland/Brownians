//
//  FiltersChain.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//
import CoreImage
import AppKit

struct FiltersChain: Equatable, Codable {
    
    nonisolated public static func == (lhs: FiltersChain, rhs: FiltersChain) -> Bool {
        lhs.chain == rhs.chain
    }
    
    enum Errors: Error {
        case filterFailed
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chain = try container.decode([Filters].self, forKey: .chain)
    }
    init(chain: [Filters]) {
        self.chain = chain
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
