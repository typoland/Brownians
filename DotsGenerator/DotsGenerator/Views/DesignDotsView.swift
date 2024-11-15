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
import Combine

//extension Publisher where Self.Failure ==  Never {
//    // because the publisher can NEVER FAIL - by design!
//    public  func sink(receiveValue: @escaping ((Self.Output) -> Void)) -> AnyCancellable {  }
//}

struct DotSizesView: View {
    @Binding var refresh: Bool
    @EnvironmentObject var manager: Manager
    @State var dots: [Dot] = []
    //@State var isRunning: Bool = true
//    var detailMap: (CGSize) -> MapType
//    var dotSizeMap: (CGSize) -> MapType
    var generator = DotGenerator()
    @State var generatorTask : Task<[Dot], Never> = Task {[]}
    
    //let previewSize: CGSize = CGSize(width: 100, height: 100)
    
//    var detailSize: (MapType, CGSize) -> (CGPoint) -> Double = {manager, frame in
//        { point in
//        manager.detailSize * (1.0-point.x/frame.width)}
//    }
//    
//    var dotSize:(MapType, CGSize) -> (CGPoint) -> Double = {manager, frame in
//        {point in manager.dotSize * (1.0-point.y/frame.height)}
//    }

    
//    var detailMap: (CGSize) -> MapType  = { size in
//        return .function(
//            Functions.verticalBlend,
//            dotSize: DotSize(minSize: 6, maxSize: 10))
//        
//    }
//    var dotSizeMap: (CGSize) -> MapType = { size in
//        return .function(
//            Functions.horizontalBlend,
//            dotSize: DotSize(minSize: 0.1, maxSize: 0.9))
//        
//    }
    
    func start(in size: CGSize) async {
       
       
        generatorTask = await generator
            .makeDotsTask(in: size, 
                      //result: &dots, 
                          detailMap: manager.det() , 
                          dotSizeMap: manager.siz(),
                      chaos: manager.chaos)
        dots =  await generatorTask.value
        refresh = false 
    }

    var body: some View {
        ZStack {
            GeometryReader {proxy in
                Canvas {context, size in                    
                    for dotIndex in 0..<dots.count {
                        let dot = dots[dotIndex]
                        let circleSize = dot.upperBound * dot.dotSize
                        let path = CircleShape()
                            .path(in: CGRect(x: dot.at.x, 
                                             y: dot.at.y, 
                                             width: circleSize, 
                                             height: circleSize))
                        context.fill(path, with: .color(.black))
                    }
                }.frame(width: proxy.size.width, height: proxy.size.height)
                    .background(refresh ? Color.red : Color.white)
                    .onAppear {
                        Task {
                            await start(in: proxy.size)
                        }
                    }
                
                    .onChange(of: refresh) {
                        if refresh {
                            Task {
                                await start(in: proxy.size)
                            }
                        }
                    }
                    .onReceive(generator.updateGeneratorDots) {_ in
                        Task {
                            self.dots = await generator.currentDots()
                        }
                    }
            }
            HStack {
                if refresh {
                    Button("Stop") {
                        generatorTask.cancel()
                        refresh = false
                    }
                }
                if refresh {
                    Button("Look") {
                        Task {
                            dots = await generator.currentDots()
                        }
                    }
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
