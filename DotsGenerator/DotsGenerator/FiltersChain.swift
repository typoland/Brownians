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
        self.chain = try container.decode([Filter].self, forKey: .chain)
    }
    init(chain: [Filter]) {
        self.chain = chain
    }
    
    var chain: [Filter]
    
    func result(source: ImageSource) throws -> ImageSource {
        var result: CIImage? = source.image
        for filter in chain {
            result = filter.filter(image: result!)
            if result == nil {
                throw Errors.filterFailed
            }
        }
        return .flatten(result!)
    }
}

extension FiltersChain: CustomStringConvertible {
    public var description: String {
        "\(chain.count) filters"
    }
    
    
}
