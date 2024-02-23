//
//  RelatedWordsView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct RelatedWordsView: View {
    private(set) var relatedWords: [Word]?
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Spacer()
                if let relatedWords, relatedWords.count > 0 {
                    List(relatedWords, id: \.id) { word in
                        Text("\(word.word)")
                        .onTapGesture {
                            print("tapped '\(word.word)'")
                        }
                    }
                    .padding([.top], 5)
                } else {
                    Text("No related words.")
                    Spacer()
                }
            }
        }
        .background(Color.green)
    }
}

struct RelatedWords_Previews: PreviewProvider {
    static var previews: some View {
        RelatedWordsView(relatedWords: [])
    }
}
