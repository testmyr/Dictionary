//
//  ContentView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State var history = ["just", "do", "it"]
    @State private var currentTab: Int = 0
    
    @EnvironmentObject private var store: Store
    var body: some View {
        TabView(selection: $currentTab) {
            ForEach(history.indices, id: \.self) { index in
                // the 'history' shouldn't/couldn't contain non-existed word
                if let word = store.getWord(word: history[index]) {
                    let _ = print(word)
                    MainView(word: word, word_: $history[index],
                             // a bit crutch but it seems no another way
                             // because an environment object is injected into _after_ initialization
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
                history.append("yourself")
            }
        }
        .onChange(of: history) { newValue in
            currentTab = history.count - 1
        }
    }
    
    private func sizes(for word: Word) -> [(CGSize, [CGSize], [(CGSize, [CGSize])])] {
        var sizes_ = Array<(CGSize, [CGSize], [(CGSize, [CGSize])])>()
        for d in word.definitions {
            var subExamples = Array<(CGSize, [CGSize])>(repeating: (.zero, []), count: d.subExamples.count)
            for subIndex in subExamples.indices {
                subExamples[subIndex].1 = Array<CGSize>(repeating: .zero, count: d.subExamples[subIndex].1.count)
            }
            sizes_.append((.zero, Array<CGSize>(repeating: .zero, count: d.examples.count), subExamples))
        }
        return sizes_
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
