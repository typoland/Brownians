//
//  DotsGeneratorApp.swift
//  DotsGenerator
//
//  Created by Łukasz Dziedzic on 11/11/2024.
//

import SwiftUI

@main
struct DotsGeneratorApp: App {
    @StateObject var manager = Manager()
    var body: some Scene {
        WindowGroup {
            ContentView(manager: manager)
        }
    }
}
