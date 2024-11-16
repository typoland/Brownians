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
    
    var generator = DotGenerator()
    @State var generatorTask : Task<[Dot], Never> = Task {[]}
    
    func start(in size: CGSize) async {
        generatorTask = await generator
            .makeDotsTask(in: size, 
                          detailMap: manager.detailSizeClosure(in:size) , 
                          dotSizeMap: manager.dotSizeClosure(in: size),
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
                                             y: size.height - dot.at.y, 
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
