//
//  Store.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import Foundation

class Store: ObservableObject {
    @Published var definitions: [String] = []
    
    init() {
#if DEBUG
        simulateData()
#endif
    }
    
    func simulateData() {
        for _ in 0...10 {
            let r = Int.random(in: 50...400)
            let definition = String(Array<Character>(repeating: "A", count: r))
            definitions.append(definition)
        }
    }
}
