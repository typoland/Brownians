//
//  ImageSource.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 19/11/2024.
//
import CoreImage
import AppKit

enum ImageSource: Codable {
    
    enum Er: Error {
        case importFailed
        case cannotSaveFlatten
    }
    
    case url(url: URL)
    case local(name: String)
    case flatten(CIImage)
    
    enum Keys: CodingKey {
        case url
        case local
        case flatten
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        if let url = try? container.decode(URL.self, forKey: .url) {
            self = .url(url: url)
        } else if let name = try? container.decode(String.self, forKey: .local) {
            self = .local(name: name)
        } else {
            throw Er.importFailed
        }
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        switch self {
        case .url(let url):
           try container.encode(url, forKey: .url)
        case .local(let name):
            try container.encode(name, forKey: .local)
        case .flatten(_):
            throw Er.cannotSaveFlatten
        }
    }
    
    var image: CIImage {
        switch self {
        case .url(let url):
            return NSImage(contentsOf: url)?.ciImage ?? Defaults.imageSource.image
        case .local(let name):
            return NSImage(named: name)!.ciImage ?? Defaults.imageSource.image
        case .flatten(let ciImage):
            return ciImage
        }
    }
}
