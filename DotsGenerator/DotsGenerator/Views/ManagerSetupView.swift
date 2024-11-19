//
//  ManagerSetupView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 18/11/2024.
//

import SwiftUI

struct ManagerSetupView: View {
    @State var refreshPreview: Bool = true
    @State var openSetup: Bool = false
    @State var saveSetup: Bool = false
    @EnvironmentObject var manager: Manager
    @State var info: String = ""
    //@State var timeElapsed: Bool = false
     
    func setInfo(_ txt: String) async {
        print (txt)
        info = txt
        try? await Task.sleep(nanoseconds: 7_500_000_000)
        info = ""
    }
    
    
    var body: some View {
        VStack {
            GenerateDotsView(refresh: $refreshPreview, 
                             savePDF: .constant(false), 
                             manager: manager)
            .frame(height: 180)
            Group {
                if refreshPreview {
                    Button(action: {refreshPreview = false}, 
                           label: {Text("Stop")})
                } else {
                    Text("Preview shows only true detail size, images are scaled down").lineLimit(3).controlSize(.mini)
                    
                }
            }.frame(maxWidth: .infinity)
                .frame(height: 30)
            HStack {
                Text("Chaos:")
                EnterTextFiledView("0,5...0,99", 
                                   value: $manager.chaos,
                                   in: 0.4...1)
            }
            HStack (alignment: .top) {
                MapTypeView(title: "Detail size",
                            map: $manager.detailMap, 
                            dotSize: $manager.detailSize,
                            range: 2...Double.infinity)
                MapTypeView(title: "Dot size",
                            map: $manager.sizeMap, 
                            dotSize: $manager.dotSize,
                            range: 0...1)
                
                
                
            }.onSubmit {
                refreshPreview = true
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
            }
            .fileImporter(isPresented: $openSetup, 
                           allowedContentTypes: [.json]) { result in
                print ("try to laoad")
                switch result {
                case .success(let url):
                    do {
                        let decoder = JSONDecoder()
                        let data = try Data(contentsOf: url)
                        let newManager = try decoder.decode(Manager.self, from: data)
                        print ("-----------")
                        print (manager.sizeOwner ," — ", newManager.sizeOwner)
                        print (manager.finalSize ," — ", newManager.finalSize)
                        print (manager.sizeMap ," — ", newManager.sizeMap)
                        print (manager.detailMap ," — ", newManager.detailMap)
                        print (manager.dotSize ," — ", newManager.dotSize)
                        print (manager.chaos ," — ", newManager.chaos)
                        print ("-----------")
                        
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
                        print ("update manager")
                        manager.update(from: newManager)
                        
                        print ("*************")
                        print (manager.sizeOwner ," — ", newManager.sizeOwner)
                        print (manager.finalSize ," — ", newManager.finalSize)
                        print (manager.sizeMap ," — ", newManager.sizeMap)
                        print (manager.detailMap ," — ", newManager.detailMap)
                        print (manager.dotSize ," — ", newManager.dotSize)
                        print (manager.chaos ," — ", newManager.chaos)
                        print ("*************")
                        
                        
                    } catch {
                        Task {
                            await setInfo(error.localizedDescription)
                        }
                    }
                    
                case .failure(let error as NSError):
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
            Text ("\(info)").animation(.easeInOut)
            
        }
        
    }
}

#Preview {
    ManagerSetupView()
        .environmentObject(Manager())
}
