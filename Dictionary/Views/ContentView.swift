//
//  ContentView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var history = HistoryManager()// mb an envr object later
    @State private var currentTab: Int = 0    
    
    @EnvironmentObject private var store: Store
    var body: some View {
        TabView(selection: $currentTab) {
            ForEach(history.items.indices, id: \.self) { index in
                pagedView(index: index)
            }
        }
        .ignoresSafeArea(edges: [.top])
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onChange(of: history.currentTab) { newValue in
            currentTab = newValue
        }
        .onChange(of: currentTab) { newValue in
            history.currentTab = newValue
        }
    }
    
    @ViewBuilder private func pagedView(index: Int) -> some View {
        // the 'history' shouldn't/couldn't contain non-existed item
        if let word = history.items[index] as? Word {
            WordView(word: word, word_: history.bindingToWord(forIndex: index), relatedWord: history.bindingToWordId(forIndex: index), phraseSelected: history.bindingToPhrase(forIndex: index),
                     // a bit crutch but it seems no another way
                     // because an environment object is injected into _after_ initialization
                     textSizes: history.bindingToSizes(forIndex: index))
            .tag(index)
        } else if let phrase = history.items[index] as? Phrase {
            PhraseView(phrase: phrase, word_: history.bindingToWord(forIndex: index), textSizes: history.bindingToSizes(forIndex: index))
        }/*  else {
//                    Text("NO WORD")
//                        .foregroundColor(Color.red)
        }*/
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Store())
    }
}
