//
//  DictionaryApp.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

@main
struct DictionaryApp: App {
    @StateObject var store = Store()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}
