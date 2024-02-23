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
                // the 'history' shouldn't/couldn't contain non-existed word
                if let word = store.getWord(word: history.items[index]) {
                    MainView(word: word, word_: history.singularBinding(forIndex: index),
                             // a bit crutch but it seems no another way
                             // because an environment object is injected into _after_ initialization
                             textSizes: history.singularBinding(forIndex: index))
                    .tag(index)
                } else {
//                    Text("NO WORD")
//                        .foregroundColor(Color.red)
                }
            }
        }
        .ignoresSafeArea(edges: [.top])
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//        .overlay {
//            Button("Add") {
//                history.items.removeLast(history.items.count - 1 - currentTab)
//                history.items.append("yourself")
//            }
//        }
        .onChange(of: history.currentTab) { newValue in
            currentTab = newValue
        }
        .onChange(of: currentTab) { newValue in
            history.currentTab = newValue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Store())
    }
}
