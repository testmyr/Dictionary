//
//  HistoryManager.swift
//  Dictionary
//
//  Created by sdk on 18.02.2024.
//

import SwiftUI

class HistoryManager: ObservableObject {
    @Published var currentTab: Int = 0
    @Published private(set) var items: [Definitionable] = []
    @Published private var itemsSizes: [Sizes] = []
    
    init() {
        // useful in case of persistent history
        // in the future: persist eg the latest 5-10
        // distinguish a word/phrase!
        let itemsIds = ["just", "do", "it", "yourself"]
        items = itemsIds.map({Store().getWord(word: $0)!})
        itemsSizes = items.map({ Self.sizes(for: $0 as! Word) })
    }
    
    func bindingToWord(forIndex index: Int) -> Binding<String> {
        Binding<String> { () -> String in
            guard index < self.items.count else {
                // exceeds by one in case of *
                // because it's affected by the page(going to be removed) that follows the replaced one
                // in other words:
                // the current view replacing precedes(in spite of assigning order) the cleaning of the next views in TabView, that's why
                return ""
            }
            return self.items[index].text
        } set: { (newValue) in
            // if a word1.word and word2.id are the same, the words are equal**
            guard newValue != self.items[index].text else {
                return
            }
            // *there are at least two in the history, the current isn't the latest
            if index < self.items.count - 1 {
                if let wordDef = Store().getWord(word: newValue) {
                    self.currentTab = index + 1
                    guard newValue != self.items[index + 1].text else {// **
                        return
                    }
                    if index + 2 <= self.items.count - 1 {
                        self.items.remove(atOffsets: IndexSet((index + 2)...(self.items.count - 1)))
                    }
                    if index + 2 <= self.itemsSizes.count - 1 {
                        self.itemsSizes.remove(atOffsets: IndexSet((index + 2)...(self.itemsSizes.count - 1)))
                    }
                    self.items[index + 1] = wordDef
                    self.itemsSizes[index + 1] = Self.sizes(for: wordDef)
                }
                // the current is the latest
            } else {
                if let wordDef = Store().getWord(word: newValue) {
                    self.currentTab = index + 1
                    self.items.append(wordDef)
                    self.itemsSizes.append(Self.sizes(for: wordDef))
                }
            }
        }
    }
    
    // used only in case a related word is clicked
    func bindingToWordId(forIndex index: Int) -> Binding<Word> {
        Binding<Word> { () -> Word in
            self.items[index] as! Word
        } set: { (newValue) in
            // this equality hardly ever could happen but let it be
            guard newValue.id != (self.items[index] as! Word).id else {
                return
            }
            // there are at least two in the history, the current isn't the latest
            if index < self.items.count - 1 {
                self.currentTab = index + 1
                guard newValue.id != (self.items[index + 1] as? Word)?.id else {
                    return
                }
                self.items[index + 1] = newValue
                if index + 2 <= self.items.count - 1 {
                    self.items.remove(atOffsets: IndexSet((index + 2)...(self.items.count - 1)))
                }
                self.itemsSizes[index + 1] = Self.sizes(for: newValue)
                if index + 2 <= self.itemsSizes.count - 1 {
                    self.itemsSizes.remove(atOffsets: IndexSet((index + 2)...(self.itemsSizes.count - 1)))
                }
                // the current is the latest
            } else {
                self.currentTab = index + 1
                self.items.append(newValue)
                self.itemsSizes.append(Self.sizes(for: newValue))
            }
        }
    }
    
    // used only in case a related phrase is clicked
    func bindingToPhrase(forIndex index: Int) -> Binding<Phrase?> {
        Binding<Phrase?> { () -> Phrase? in
            self.items[index] as? Phrase
        } set: { (newValue) in
            if let newValue = newValue {
                // there are at least two in the history, the current isn't the latest
                if index < self.items.count - 1 {
                    self.currentTab = index + 1
                    guard newValue != (self.items[index + 1] as? Phrase) else {
                        return
                    }
                    self.items[index + 1] = newValue
                    if index + 2 <= self.items.count - 1 {
                        self.items.remove(atOffsets: IndexSet((index + 2)...(self.items.count - 1)))
                    }
                    self.itemsSizes[index + 1] = Self.sizes(for: newValue)
                    if index + 2 <= self.itemsSizes.count - 1 {
                        self.itemsSizes.remove(atOffsets: IndexSet((index + 2)...(self.itemsSizes.count - 1)))
                    }
                    // the current is the latest
                } else {
                    self.currentTab = index + 1
                    self.items.append(newValue)
                    self.itemsSizes.append(Self.sizes(for: newValue))
                }
            }
        }
    }
    
    func bindingToSizes(forIndex index: Int) -> Binding<Sizes> {
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
    
    static func sizes(for word: Definitionable) -> Sizes {
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
