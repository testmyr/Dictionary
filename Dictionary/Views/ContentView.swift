//
//  ContentView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State var history = ["just", "do", "it", "yourself"].map({Word(word: $0)})
    @State private var currentTab: Int = 0
    
    @EnvironmentObject private var store: Store
    var body: some View {
        TabView(selection: $currentTab) {
            ForEach(history.indices, id: \.self) { index in
                let wordDefinitions = store.simulatedDefenitions()
                MainView(word: $history[index].word,
                         definitions: wordDefinitions,
                         // a bit crutch but it seems no another way
                         textSizes: Array<CGSize>(repeating: .zero, count: wordDefinitions.count))
                .tag(index)
            }
        }
        .ignoresSafeArea(edges: [.top])
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay {
            Button("Add") {
                history.removeLast(history.count - 1 - currentTab)
                history.append(Word(word: "sample"))
            }
        }
        .onChange(of: history) { newValue in
            currentTab = history.count - 1
        }
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
