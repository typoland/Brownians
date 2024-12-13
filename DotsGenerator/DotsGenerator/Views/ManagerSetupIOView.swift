//
//  SetupIOView.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/12/2024.
//

import SwiftUI

//struct ManagerSetupIOView: View {
//    enum FuckinError: Error {
//        case failedToSave
//        case failedToLoad
//    }
//    
//    @State var openSetup: Bool = false
//    @State var saveSetup: Bool = false
//    var taskCompletion: ((String) -> Void)? = nil
//    
//    @EnvironmentObject var manager: Manager
//    var body: some View {
//        HStack {
//            Button("save Setup", action: {
//                print("touched save")
//                saveSetup = true
//            })
//            Button("load Setup", action: {
//                print("touched load \(openSetup)")
//                openSetup = true
//                print("so? load \(openSetup)")
//            })
//        }
//        .focusedValue(\.openSetup, $openSetup)
//        .focusedValue(\.saveSetup, $saveSetup)
//        
//        .fileExporter(isPresented: $saveSetup,
//                      items: [manager]) { result in
//            
//            switch result {
//            case let .success(suc):
//                taskCompletion?("OK: \(suc)")
//            case let .failure(error as NSError):
//                taskCompletion?("\(error.localizedDescription)")
//            }
//        }
//        
//        .fileImporter(isPresented: $openSetup,
//                      allowedContentTypes: [.json]) { result in
//            print("try to laoad")
//            switch result {
//            case let .success(url):
//                do {
//                    guard  url.startAccessingSecurityScopedResource() else {throw FuckinError.failedToLoad}
//                    let decoder = JSONDecoder()
//                    let data = try Data(contentsOf: url)
//                    let newManager = try decoder.decode(Manager.self, from: data)
//                    debugPrint("-----old Manager------")
//                    debugPrint(manager)
//                    debugPrint("-----------")
//                                  
//                    if case let .image(_, importedFilters) = newManager.detailMap,
//                       case let .image(existingImage, _) = manager.detailMap
//                    {
//                        newManager.detailMap = .image(image: existingImage,
//                                                      filters: importedFilters)
//                    }
//                                  
//                    if case let .image(_, importedFilters) = newManager.sizeMap,
//                       case let .image(existingImage, _) = manager.sizeMap
//                    {
//                        newManager.sizeMap = .image(image: existingImage,
//                                                    filters: importedFilters)
//                    }
//                    debugPrint("update manager")
//                    manager.update(from: newManager)
//                                  
//                    debugPrint("****** manager *******")
//                    debugPrint(manager)
//                    debugPrint("*************")
//                    taskCompletion?("OK") // refreshPreview = true
//                                  
//                } catch let error as NSError {
//                    taskCompletion?("\(error.localizedDescription)")
//                }
//                              
//            case let .failure(error as NSError):
//                taskCompletion?("\(error.localizedDescription)")
//            }
//        }
//    }
//}
//
//#Preview {
//    ManagerSetupIOView()
//}
