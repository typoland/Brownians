//
//  DesignDotsView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 12/11/2024.
//

import SwiftUI

//struct DesignDotsView: View {
//    @ObservedObject var manager: Manager
//    var body: some View {
//        HStack {
//            DotSizesView(manager: manager)
//        }
//    }
//}

struct DotSizesView: View {
    @Binding var refresh: Bool
    @EnvironmentObject var manager: Manager
    @State var dots: [Dot] = []
    @State var isRunning: Bool = true
    var generator = DotGenerator()
    @State var generatorTask : Task<[Dot], Never> = Task {[]}
    //let previewSize: CGSize = CGSize(width: 100, height: 100)
    
    var detailSize: (Manager, CGSize) -> (CGPoint) -> Double = {manager, frame in
        { point in
        manager.detailSize * (1.0-point.x/frame.width)}
    }
    
    var dotSize:(Manager, CGSize) -> (CGPoint) -> Double = {manager, frame in
        {point in manager.dotSize * (1.0-point.y/frame.height)}
    }
//    func makeDots(in frame: CGSize) async -> () async -> Void {
//         {
//          
//            let makeDots =  await generator.makeDots(in: frame, 
//                                                     //result: &dots, 
//                                                     detailSize: detailSize(manager, frame), 
//                                                     dotSize: dotSize(manager, frame),
//                                                     chaos: manager.chaos)
//            
//            
//            
//            if !isRunning {makeDots.cancel()}
//            
//            dots = await makeDots.value
//            isRunning = false
//        }
//    }
    
    func start(in size: CGSize) async {
        isRunning = true
        generatorTask = await generator
            .makeDots(in: size, 
                      //result: &dots, 
                      detailSize: detailSize(manager, size), 
                      dotSize: dotSize(manager, size),
                      chaos: manager.chaos)
        
        
        
        
        
        dots =  await generatorTask.value
        isRunning = false
        refresh = false 
    }
    
    
    var body: some View {
        ZStack {
            GeometryReader {proxy in
                Canvas {context, size in
                    print ("context \(size)")
                    
                    for dotIndex in 0..<dots.count {
                        let dot = dots[dotIndex]
                        let circleSize = dot.upperBound * dot.dotSize
                        let path = CircleShape().path(in: CGRect(x: dot.at.x, 
                                                                 y: dot.at.y, 
                                                                 width: circleSize, 
                                                                 height: circleSize))
                        context.fill(path, with: .color(.black))
                    }
                }.frame(width: proxy.size.width, height: proxy.size.height)
                    .background(isRunning ? Color.red : Color.white)
                    .onAppear {
                        Task {
                            await start(in: proxy.size)
                            refresh = false
                        }
                    }
                 
                    .onChange(of: refresh) {
                        
                        if refresh {
                            Task {
                                await start(in: proxy.size)
                            }
//                            
                        }
                    }
            }
            if isRunning {
                Button("Stop") {
                   generatorTask.cancel()
                    isRunning = false
                    refresh = false
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var refresh: Bool = true
    DotSizesView(refresh: $refresh)
        .frame(width: 40, height: 40)
        .environmentObject( Manager())
}
