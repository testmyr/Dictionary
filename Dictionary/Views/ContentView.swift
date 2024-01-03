//
//  ContentView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State var history = ["just", "do", "it", "yourself"].map({Word_(word: $0)})
    @State private var currentTab: Int = 0
    
    @EnvironmentObject private var store: Store
    var body: some View {
        TabView(selection: $currentTab) {
            ForEach(history.indices, id: \.self) { index in
                // the 'history' shouldn't/couldn't contain non-existed word
                if let word = store.getWord(word: history[index].word) {
                    let _ = print(word)
                    MainView(word: word, word_: $history[index].word,
                             // a bit crutch but it seems no another way
                             textSizes: sizes(for: word))
                    .tag(index)
                } else {
                    Text("NO WORD")
                        .foregroundColor(Color.red)
                }
            }
        }
        .ignoresSafeArea(edges: [.top])
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay {
            Button("Add") {
                history.removeLast(history.count - 1 - currentTab)
                history.append(Word_(word: "sample"))
            }
        }
        .onChange(of: history) { newValue in
            currentTab = history.count - 1
        }
    }
    
    private func sizes(for word: Word) -> [(CGSize, [CGSize])] {
        var sizes = Array<(CGSize, [CGSize])>()
        for d in word.definitions {
            sizes.append((.zero, Array<CGSize>(repeating: .zero, count: d.examples.count)))
        }
        return sizes
    }
    
    private func correctedIndex(for index: Int) -> Int {
        let count = history.count
        return (count + index) % count
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Store())
    }
}
