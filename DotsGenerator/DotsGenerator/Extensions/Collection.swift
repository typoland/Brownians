//
//  Collection.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 25/11/2024.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
}
