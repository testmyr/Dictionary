//
//  RelatedWordsView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct RelatedWordsView: View {
    @Binding var releatedWordSelected: Word?
    private(set) var relatedWords: [Word]?
    
    private let colorBg = Color.white
    var body: some View {
        VStack() {
            if let relatedWords, relatedWords.count > 0 {
                List(relatedWords, id: \.id) { word in
                    HStack {
                        Spacer()
                        Text("\(word.word)")
                            .rotationEffect(.degrees(180))
                    }
                    .background(colorBg)
                    .onTapGesture {
                        releatedWordSelected = word
                        print("tapped '\(word.word)'")
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        0
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .rotationEffect(.degrees(180))
            } else {
                Spacer()
                HStack {
                    Text("No related words.")
                    Spacer()
                }
                Spacer()
            }
        }
        .background(colorBg)
    }
}

struct RelatedWords_Previews: PreviewProvider {
    static var previews: some View {
        RelatedWordsView(releatedWordSelected: .constant(Store().getWord(word: "do")!), relatedWords: [Store().getWord(word: "just")!, Store().getWord(word: "do")!])
    }
}
