//
//  Comparable.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 17/11/2024.
//

    extension Comparable {
        func clamped(to limits: ClosedRange<Self>) -> Self {
            return min(max(self, limits.lowerBound), limits.upperBound)
        }
    }

