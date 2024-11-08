//
//  TestView.swift
//  
//
//  Created by Łukasz Dziedzic on 06/11/2024.
//
import Foundation
import SwiftUI

let colors: [Color] = [Color(red: 1.0, green: 0.0, blue: 0.0),
                       Color(red: 0.0, green: 1.0, blue: 0.0),
                       Color(red: 0.0, green: 0.0, blue: 1.0),
                       Color(red: 0.0, green: 0.0, blue: 0.0),
]


public struct TestView: View {
    var res: Int
    
    public init(res: Int = 20){
        self.res = res
    }
    
    func toRad(_ index: Int) -> Double {
        Double(index)/Double(res) * Double.tau - Double.pi / 4
    }
    func getOrbits(row: Int, column: Int) -> AnglesRanges {
        var a = AnglesRanges()
        for i in 0...row {
            //let c = toRad(column)
            let r = toRad(i)
            let t = (Double(column) / Double(res))
            let s = (toRad(1)-toRad(0)) * (t)
            let shift = 45.0.radians
            a.add(from: r - shift, to: (r+s*0.9)-shift)
        }
//        a.add(from: toRad(row), to: toRad(column))
//        a.add(from: toRad(row - 10), to: toRad(row-10+column-3))
        
        //a.remove(range: toRad(0)...toRad(row))
        return a
    }
    
    public var body: some View {
        VStack{
            
            GeometryReader { proxy in
                VStack (spacing: 0) {
                    ForEach((0...res).indices, id:\.self) {rowIndex in
                        if case .inRange(let row) = rowIndex {
                            HStack (spacing: 0){
                                ForEach((0...res).indices, id:\.self) {columnIndex in
                                    if case .inRange( let column) = columnIndex {
                                        //let a = Int(Double(Int.random(in: 0...res)))///8.0)
                                        //getOrbits(row: Int.random(in: 0...res), column: Int.random(in: 0...res))
                                        getOrbits(row: row, column: column)
                                            .view(color: someColor(index: column + row))
                                    }                                    
                                }
                            }
                        }
                        
                    }
                }
            }
        }.background(Color.white)
        
    }
}


