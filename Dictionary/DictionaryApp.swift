//
//  DictionaryApp.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

// no working preview if they are in the HistoryManager instead of. buggish xcode/swiftUI..
typealias DefinitionSizes = (CGSize, [CGSize], [(CGSize, [CGSize])])
typealias Sizes = [DefinitionSizes]

@main
struct DictionaryApp: App {
    @StateObject var store = Store()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}
