//
//  WhiteNoiseMachineSwiftUIApp.swift
//  WhiteNoiseMachineSwiftUI
//
//  Created by Matt Hoosier on 3/26/22.
//

import SwiftUI

@main
struct WhiteNoiseMachineSwiftUIApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Don't want the New Window and Close menu items. These don't really
        // make sense for this application, because it doesn't manage documents.
        .commands {
            // New Window
            CommandGroup(replacing: CommandGroupPlacement.newItem) {
                EmptyView()
            }
            // Close Window
            CommandGroup(replacing: CommandGroupPlacement.saveItem) {
                EmptyView()
            }
        }
    }
}
