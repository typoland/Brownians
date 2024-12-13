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
   // @State var openSetup: Bool = false
   // @State var saveSetup: Bool = false

    @State var info: String = ""
    @State var timeElapsed: Bool = false
    @State var popover: Bool = false

    @State var dotShapeTypeIndex = 0

   

    @State var layer: Layer = .darkness

    @ViewBuilder
    var popoverContent: some View {
        VStack {
            Picker("dot Type", selection: $dotShapeTypeIndex) {
                Text("Oval").tag(0)
                Text("Rectangle").tag(1)
                Text("Triangle").tag(2)
                Text("Diamond").tag(3)
            }.onChange(of: dotShapeTypeIndex) {
                let shapeSize = manager.dotShape.size
                if let new = try? DotShapeType(index: dotShapeTypeIndex,
                                               size: shapeSize) {
                    manager.dotShape = new
                }
            }
            switch manager.dotShape {
            case let .oval(shapeSize):
                let binding = Binding(get: { shapeSize },
                                      set: { manager.dotShape = .oval(size: $0) })
                CGSizeView(size: binding, range: 0 ... 4)
            case let .rectangle(shapeSize):
                let binding = Binding(get: { shapeSize },
                                      set: { manager.dotShape = .rectangle(size: $0) })
                CGSizeView(size: binding, range: 0 ... 4)
            case let .triangle(shapeSize):
                let binding = Binding(get: { shapeSize },
                                      set: { manager.dotShape = .triangle(size: $0) })
                CGSizeView(size: binding, range: 0 ... 4)
            case let .diamond(shapeSize):
                let binding = Binding(get: { shapeSize },
                                      set: { manager.dotShape = .diamond(size: $0) })
                CGSizeView(size: binding, range: 0 ... 4)
            }
        }.padding(12)
            .frame(width: 300)
            .controlSize(.mini)
    }

    @ViewBuilder
    var dotsPreview: some View {
        GenerateDotsView(refresh: $refreshPreview,
                         savePDF: .constant(false))
            .environmentObject(manager)
            .frame(height: 180)

        HStack {
            if refreshPreview {
                Button(action: { refreshPreview = false },
                       label: { Image(systemName: "eye.slash.circle.fill") })
            } else {
                Button(action: { refreshPreview = true },
                       label: { Image(systemName: "eye.circle.fill") })
            }
            Text("Preview shows only true detail size, \nimages are scaled down to fit").lineLimit(3).controlSize(.mini)

            Spacer()

            Button(action: { popover = true },
                   label: { Image(systemName: "gearshape.fill") })
        }.buttonStyle(.borderless)
            .frame(width: 280, height: 30)
            .onAppear { dotShapeTypeIndex = manager.dotShape.index }
            .popover(isPresented: $popover,
                     attachmentAnchor: .point(UnitPoint(x: 0.96, y: 0.85)),
                     arrowEdge: .bottom) {
                popoverContent
            }
    }

    @ViewBuilder
    var setup: some View {
        VStack {
            HStack {
                Text("Chaos:")
                EnterTextFiledView(titleKey: "0,5...0,99",
                                   value: $manager.chaos,
                                   range: 0.3 ... 1)
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
                            dotSize: $manager.dotSize, sizeOwner: .sizeMap,
                            range: 0 ... 1)
                    .environmentObject(manager)

            case .detail:
                MapTypeView(title: "Detail size",
                            map: $manager.detailMap,
                            dotSize: $manager.detailSize, sizeOwner: .detailMap,
                            range: 2 ... 1000)
                    .environmentObject(manager)

            case .angle:
                MapTypeView(title: "rotation",
                            map: $manager.rotationMap,
                            dotSize:
                            $manager.rotationLimits, sizeOwner: .rotationMap,
                            range: -360 ... 360)
            }
        }

        .onSubmit {
            refreshPreview = false
            Task {
                try? await Task.sleep(nanoseconds: 1000000)
                refreshPreview = true
            }
        }
    }

    

    var body: some View {
        VStack {
             dotsPreview
            setup
            Spacer()
            //IO
            
        }
    }
}

#Preview {
    ManagerSetupView()
        .environmentObject(Manager())
}

/*
 @ViewBuilder
 var IO: some View {
 HStack {
 Button("save Setup", action: {
 print("touched save")
 saveSetup = true
 })
 Button("load Setup", action: {
 print("touched load")
 openSetup = true
 })
 }
 .focusedValue(\.openSetup, $openSetup)
 .focusedValue(\.saveSetup, $saveSetup)
 
 .fileImporter(isPresented: $openSetup,
 allowedContentTypes: [.json]) { result in
 print("try to laoad")
 switch result {
 case let .success(url):
 do {
 let decoder = JSONDecoder()
 let data = try Data(contentsOf: url)
 let newManager = try decoder.decode(Manager.self, from: data)
 debugPrint("-----old Manager------")
 debugPrint(manager)
 debugPrint("-----------")
 
 if case let .image(_, importedFilters) = newManager.detailMap,
 case let .image(existingImage, _) = manager.detailMap {
 newManager.detailMap = .image(image: existingImage,
 filters: importedFilters)
 }
 
 if case let .image(_, importedFilters) = newManager.sizeMap,
 case let .image(existingImage, _) = manager.sizeMap {
 newManager.sizeMap = .image(image: existingImage,
 filters: importedFilters)
 }
 debugPrint("update manager")
 manager.update(from: newManager)
 
 debugPrint("****** manager *******")
 debugPrint(manager)
 debugPrint("*************")
 setInfo("OK") // refreshPreview = true
 
 } catch let error as NSError {
 setInfo("\(error.localizedDescription)")
 }
 
 case let .failure(error as NSError):
 setInfo("\(error.localizedDescription)")
 }
 }
 .fileExporter(isPresented: $saveSetup,
 items: [manager]) { result in
 
 switch result {
 case let .success(suc):
 setInfo("OK: \(suc)")
 case let .failure(error as NSError):
 setInfo("\(error.localizedDescription)")
 }
 }
 }
 */
