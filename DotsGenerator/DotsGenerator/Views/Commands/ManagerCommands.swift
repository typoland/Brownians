//
//  ManagerCommands.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 10/12/2024.
//

import SwiftUI

struct ManagerCommands: Commands {
    
    @FocusedBinding(\.savePath) var savePath: Bool?
    @FocusedBinding(\.saveFile) var saveFile: Bool?
    @FocusedBinding(\.openSetup) var openSetup: Bool?
    @FocusedBinding(\.saveSetup) var saveSetup: Bool?
    
    var body: some Commands {
        CommandGroup(before: CommandGroupPlacement.newItem) {
        //CommandGroup(replacing: CommandGroupPlacement.newItem) {
            Button("Choose Save Folder") {
                savePath = true
            }.keyboardShortcut("s", modifiers: [.control ,.option])
            Button("Save Rendred Image") {
                saveFile = true
            }.keyboardShortcut("s", modifiers: [.control])
//            Button("Open Setup") {
//                openSetup = true
//            }.keyboardShortcut("o", modifiers: .control)
//            Button("Save Setup") {
//                saveSetup = true
//            }.keyboardShortcut("s", modifiers: .control)
        }
    }
}

private struct SavePath: FocusedValueKey {
    typealias Value = Binding<Bool>
}

private struct SaveFile: FocusedValueKey {
    typealias Value = Binding<Bool>
}

private struct SaveSetup: FocusedValueKey {
    typealias Value = Binding<Bool>
}

private struct OpenSetup: FocusedValueKey {
    typealias Value = Binding<Bool>
}


extension FocusedValues {
    var savePath: Binding<Bool>? {
        get { self [SavePath.self] }
        set { self [SavePath.self] = newValue }
    }
    
    var saveFile: Binding<Bool>? {
        get { self [SaveFile.self] }
        set { self [SaveFile.self] = newValue }
    }
    
    var saveSetup: Binding<Bool>? {
        get { self [SaveSetup.self] }
        set { self [SaveSetup.self] = newValue }
    }
    
    var openSetup: Binding<Bool>? {
        get { self [OpenSetup.self] }
        set { self [OpenSetup.self] = newValue }
    }
}
