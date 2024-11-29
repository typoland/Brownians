//
//  ManagerSetupView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 18/11/2024.
//

import SwiftUI

struct ManagerSetupView: View {
    
    @EnvironmentObject var manager: Manager
    
    @State var refreshPreview: Bool = true
    @State var openSetup: Bool = false
    @State var saveSetup: Bool = false
    
    @State var info: String = ""
    @State var timeElapsed: Bool = false
    @State var popover: Bool = false
    
    @State var dotShapeTypeIndex = 0
    
    func setInfo(_ txt: String) async {
        print (txt)
        info = txt
        try? await Task.sleep(nanoseconds: 7_500_000_000)
    }
    @State var layer: Layer = .darkness
    
    var body: some View {
        VStack {
            
            GenerateDotsView(refresh: $refreshPreview, 
                             savePDF: .constant(false))
            .environmentObject(manager)
            .frame(height: 180)
            .onTapGesture {
                popover = true
            }
            .popover(isPresented: $popover, 
                     attachmentAnchor: .point(UnitPoint(x: 0.5, y: 0.8)), 
                     arrowEdge: .bottom) {
                VStack {
                    
                    Picker("dot Type", selection: $dotShapeTypeIndex) {
                        Text ("Oval").tag(0)
                        Text("Rectangle").tag(1)
                        Text("Triangle").tag(2)
                        Text("Diamond").tag(3)
                    }.onChange(of: dotShapeTypeIndex) {
                        if let new = try? DotShapeType(index: dotShapeTypeIndex) {
                            manager.dotShape = new
                        }
                    }
                    switch manager.dotShape {
                    case .oval(let size):
                        let binding = Binding(get: {size}, set: {manager.dotShape = .oval(size: $0)})
                        CGSizeView(size: binding, range: 0...4)
                    case .rectangle(let size):
                        let binding = Binding(get: {size}, set: {manager.dotShape = .rectangle(size: $0)})
                        CGSizeView(size: binding, range: 0...4)
                    case .triangle(let size):
                        let binding = Binding(get: {size}, set: {manager.dotShape = .triangle(size: $0)})
                        CGSizeView(size: binding, range: 0...4)
                    case .diamond(let size):
                        let binding = Binding(get: {size}, set: {manager.dotShape = .diamond(size: $0)})
                        CGSizeView(size: binding, range: 0...4)
                    }
                    
                }.padding(12)
                    .frame(width: 300)
                    .controlSize(.mini)
                   
                
                
            }.frame(width: 400, height: 200, alignment: .top)  
                .onAppear {dotShapeTypeIndex = manager.dotShape.index}
            
            Group {
                if refreshPreview {
                    Button(action: {refreshPreview = false}, 
                           label: {Text("Stop")})
                } else {
                    HStack {
                        Button(action: {refreshPreview = true}, label: {Text(">")})
                        Text("Preview shows only true detail size, images are scaled down to fit").lineLimit(3).controlSize(.mini)
                    }
                    
                }
            }
            //.frame(maxWidth: .infinity)
            .frame(height: 30)
            
            VStack {
                HStack {
                    Text("Chaos:")
                    EnterTextFiledView("0,5...0,99", 
                                       value: $manager.chaos,
                                       in: 0.3...1)
                }
                Picker("", selection: $layer) {
                    ForEach(Layer.allCases, id: \.self.rawValue) { name in
                        Text("\(name)").tag(name)
                    }
                }.pickerStyle(.segmented)
                switch layer {
                case .darkness:
                    MapTypeView(title: "Dot size",
                                map: $manager.sizeMap, 
                                dotSize: $manager.dotSize, 
                                range: 0...1)
                    .environmentObject(manager)
                    
                case .detail:    
                    MapTypeView(title: "Detail size",
                                    map: $manager.detailMap, 
                                    dotSize: $manager.detailSize, 
                                    range: 2...1000)
                        .environmentObject(manager)
                
                case .angle:
                        MapTypeView(title: "rotation", 
                                    map: $manager.rotationMap, 
                                    dotSize: 
                                        $manager.rotationLimits,
                                    range: -360...360)
                }
                
                //                }
            }
            .onSubmit {
                refreshPreview = false
                Task {
                    try?  await Task.sleep(nanoseconds: 1_000_000)
                    refreshPreview = true
                }
            }
            Spacer()
            HStack {
                Button("save Setup", action: {
                    print ("touched load")
                    saveSetup = true
                })
                Button("load Setup", action: {
                    print ("touched load")
                    openSetup = true
                })
            }.fileImporter(isPresented: $openSetup, 
                           allowedContentTypes: [.json]) { result in
                print ("try to laoad")
                switch result {
                case .success(let url):
                    do {
                        let decoder = JSONDecoder()
                        let data = try Data(contentsOf: url)
                        let newManager = try decoder.decode(Manager.self, from: data)
                        debugPrint ("-----old Manager------")
                        debugPrint (manager)
                        debugPrint ("-----------")
                        
                        if case .image(_, let importedFilters) = newManager.detailMap,
                           case .image(let existingImage, _) = manager.detailMap
                        {
                            newManager.detailMap = .image(image: existingImage, filters: importedFilters)
                        }
                        
                        if case .image(_, let importedFilters) = newManager.sizeMap,
                           case .image(let existingImage, _) = manager.sizeMap
                        {
                            newManager.sizeMap = .image(image: existingImage, filters: importedFilters)
                        }
                        debugPrint ("update manager")
                        manager.update(from: newManager)
                        
                        debugPrint ("****** manager *******")
                        debugPrint (manager)
                        print ("*************")
                        refreshPreview = true
                        Task {
                            await setInfo("OK")
                        }
                        
                    } catch let error as NSError {
                        debugPrint("ERROR \(error)")
                        Task {
                            await setInfo(error.localizedDescription)
                        }
                    }
                    
                case .failure(let error as NSError):
                    debugPrint("ERROR \(error)")
                    Task {
                        await setInfo(error.localizedDescription)
                        
                    }
                }
                
            }.fileExporter(isPresented: $saveSetup, 
                           items: [manager]) { result in
                
                switch result {
                    
                case .success(let suc):
                    print ("sukces", suc)
                case .failure(let error as NSError):
                    Task {
                        await setInfo(error.localizedDescription)
                    }
                }
            }
#if DEBUG
            Text ("\(timeElapsed ? info : manager.description)").animation(.easeInOut)
#else
            Text ("\(timeElapsed ? info : "")").animation(.easeInOut)
#endif
            
        }
        
    }
}

#Preview {
    ManagerSetupView()
        .environmentObject(Manager())
}
