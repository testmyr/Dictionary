//
//  ContentView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var history = HistoryManager()
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
            WordView(word: word, index: index, history: history)
        } else if let phrase = history.items[index] as? Phrase {
            PhraseView(phrase: phrase, index: index, history: history)
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
