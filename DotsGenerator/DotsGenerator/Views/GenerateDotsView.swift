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

struct GenerateDotsView: View {
    @Binding var refresh: Bool
    @Binding var savePDF: Bool
    @ObservedObject var manager: Manager
    @State var dots: [Dot] = []
    @State var startPoint : CGPoint = CGPoint()
    var generator = DotGenerator()
    @State var generatorTask : Task<[Dot], Never> = Task {[]}
    @State var isDragged : Bool = false
    
    func start(in size: CGSize, manager: Manager) async {
        generatorTask = await generator
            .makeDotsTask(in: size, 
                          detailMap: manager.detailSizeClosure(in:size) , 
                          dotSizeMap: manager.dotSizeClosure(in: size),
                          chaos: manager.chaos,
                          startAt: startPoint)
        dots =  await generatorTask.value
        refresh = false 
    }
    
    var setStartPoint: some Gesture {
        DragGesture (minimumDistance: 0.1, coordinateSpace: .local)
            .onChanged({touch in 
                startPoint = touch.location
                isDragged = true
            })
            .onEnded({_ in isDragged = false})
    }
    
    var body: some View {
        ZStack {
            GeometryReader {proxy in
                DotView(dots: dots, size: proxy.size, savePDF: $savePDF)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .background(refresh ? Color.red : Color.white)
                    .onAppear {
                        startPoint = CGPoint(x: proxy.size.width/2, 
                                             y: proxy.size.height/2)
                        if refresh {
                            Task {
                                await start(in: proxy.size, manager: manager)
                            }
                        }
                    }
                
                    .onChange(of: refresh) {
                        if refresh {
                            Task {
                                await start(in: proxy.size, manager: manager)
                            }
                        } else {
                            generatorTask.cancel()
                            refresh = false
                        }
                    }
                    .onReceive(generator.updateGeneratorDots) {_ in
                        Task {
                            self.dots = await generator.currentDots()
                            
                        }
                        
                    }
                    .gesture(setStartPoint)
            }
            if isDragged {
                Circle()
                    .fill(Color.red)
                    .frame(width: 10, height: 10)
                    .position(startPoint)
            }           
        }
    }
}

#Preview {
    @Previewable @State var refresh: Bool = true
    GenerateDotsView(refresh: $refresh, 
                     savePDF: .constant(false), 
                     manager: Manager())
        .frame(width: 40, height: 40)
        .environmentObject( Manager())
}
