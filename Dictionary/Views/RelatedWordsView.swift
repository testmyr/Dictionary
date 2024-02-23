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
                if let relatedWords, relatedWords.count > 0 {
                    List(relatedWords, id: \.id) { word in
                        HStack {
                            Spacer()
                            Text("\(word.word)")
                                .rotationEffect(.degrees(180))
                                .onTapGesture {
                                    print("tapped '\(word.word)'")
                            }
                        }
                        .alignmentGuide(.listRowSeparatorLeading) { _ in
                            0
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding([.bottom], 20)
                    .rotationEffect(.degrees(180))
                } else {
                    Spacer()
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
