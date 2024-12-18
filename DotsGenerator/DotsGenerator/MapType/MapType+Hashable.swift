//
//  MapType+Hashable.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 19/11/2024.
//


extension MapType: Hashable {
    
    static func == (lhs: MapType, rhs: MapType) -> Bool {
        switch (lhs, rhs) {
        case (.image(let s1, let filters1), .image(let s2, let filters2)): 
            return filters1 == filters2 && s1.image == s2.image
        case (.function(let f1), .function(let f2)) : 
            return f1.formula == f2.formula
        case (.gradient(let t1, let s1, let d1), .gradient(let t2, let s2, let d2)) :
            return t1 == t2 && s1 == s2 && d1.hashValue == d2.hashValue
       
        default: return false
        }
    }
    
    var index : Int {
        switch self {
        case .image:
            return 0
        case .function:
            return 1
        case .gradient:
            return 2
        }
    }
    
//    var name: String {
//        switch self {
//        case .image:
//            return MapTypeNames.image.rawValue
//        case .function:
//            return MapTypeNames.function.rawValue
//        }
//    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .image(let image, let filters):
            hasher.combine(filters.hashValue)
            hasher.combine(image.image.hashValue)
        case .function(let functions):
            hasher.combine(functions.hashValue)
        case .gradient(let type,let stops, let data):
            hasher.combine(type)
            hasher.combine(data)
            hasher.combine(stops)
        }
    }
    
}
