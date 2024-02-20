//
//  History.swift
//  Dictionary
//
//  Created by sdk on 18.02.2024.
//

import SwiftUI

typealias DefinitionSizes = (CGSize, [CGSize], [(CGSize, [CGSize])])
typealias Sizes = [DefinitionSizes]
class History: ObservableObject {
    @Published var currentTab: Int = 0
    @Published private(set) var items = ["just", "do", "it", "yourself"]
    @Published private var itemsSizes: [Sizes] = []
    
    init() {
        // useful in case of persistent history
        // in the future: persist eg the latest 5-10
        items.forEach { word in
            itemsSizes.append(sizes(for: Store().getWord(word: word)!))
        }
    }
    
    func singularBinding(forIndex index: Int) -> Binding<String> {
        Binding<String> { () -> String in
            self.items[index]
        } set: { (newValue) in
            guard newValue != self.items[index] else {
                return
            }
            // there are at least two in the history, the current isn't the latest
            if index < self.items.count - 1 {
                if let wordDef = Store().getWord(word: newValue) {
                    self.currentTab = index + 1
                    guard newValue != self.items[index + 1] else {
                        return
                    }
                    self.items[index + 1] = newValue
                    if index + 2 <= self.items.count - 1 {
                        self.items.remove(atOffsets: IndexSet((index + 2)...(self.items.count - 1)))
                    }
                    self.itemsSizes[index + 1] = self.sizes(for: wordDef)
                    if index + 2 <= self.itemsSizes.count - 1 {
                        self.itemsSizes.remove(atOffsets: IndexSet((index + 2)...(self.itemsSizes.count - 1)))
                    }
                }
                // the current is the latest
            } else {
                if let wordDef = Store().getWord(word: newValue) {
                    self.currentTab = index + 1
                    self.items.append(newValue)
                    self.itemsSizes.append(self.sizes(for: wordDef))
                }
            }
        }
    }

    func singularBinding(forIndex index: Int) -> Binding<Sizes> {
        Binding<Sizes> { () -> Sizes in
//            if index < self.itemsSizes.count {
                return self.itemsSizes[index]
//            } else {
//
//            }
        } set: { (newValue) in
            self.itemsSizes = self.itemsSizes.enumerated().map { itemIndex, item in
                if index == itemIndex {
                    return newValue
                } else {
                    return item
                }
            }
        }
    }
    
    private func sizes(for word: Word) -> Sizes {
        var sizes_ = Array<DefinitionSizes>()
        for d in word.definitions {
            var subExamples = Array<(CGSize, [CGSize])>(repeating: (.zero, []), count: d.subExamples.count)
            for subIndex in subExamples.indices {
                subExamples[subIndex].1 = Array<CGSize>(repeating: .zero, count: d.subExamples[subIndex].1.count)
            }
            sizes_.append((.zero, Array<CGSize>(repeating: .zero, count: d.examples.count), subExamples))
        }
        return sizes_
    }
}
