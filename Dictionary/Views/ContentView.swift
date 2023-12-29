//
//  ContentView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    private var history = ["just", "do", "it", "yourself"]
    @State private var currentWordIndex = 0
    
    var body: some View {
        InfinitePageView(
            selection: $currentWordIndex,
                    before: { correctedIndex(for: $0 - 1) },
                    after: { correctedIndex(for: $0 + 1) },
                    view: { index in
                        //store.definitions[index]
                        MainView(wordInitial: history[index])
                    }
                )
        .ignoresSafeArea(edges: [.top])
        
//        TabView {
//            MainView(wordInitial: history[currentWordIndex])
//            Text("dsfdf")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .contentShape(Rectangle())
//            .simultaneousGesture(DragGesture())
//            Text("dsfds")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .contentShape(Rectangle())
//                .gesture(DragGesture())
//        }
//        .ignoresSafeArea(edges: [.top])
//        .tabViewStyle(PageTabViewStyle())
    }
    
    func correctedIndex(for index: Int) -> Int {
        let count = history.count
        return (count + index) % count
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
