//
//  DotsGeneratorApp.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import SwiftUI

@main
struct DotsGeneratorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Manager()) { file in
            ContentView(manager: file.document)
        }
        .commands {
            ManagerCommands()
        }
    }
}
