//
//  RelatedPhrasesView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct RelatedPhrasesView: View {
    @Binding var phraseSelected: Phrase?
    private(set) var relatedPhrases: [Phrase]?
    
    private let colorBg = Color.white
    var body: some View {
        VStack() {
            if let relatedPhrases, relatedPhrases.count > 0 {
                List(relatedPhrases, id: \.phrase) { phrase in
                    HStack {
                        Spacer()
                        Text("\(phrase.phrase)")
                            .rotationEffect(.degrees(180))
                    }
                    .background(colorBg)
                    .onTapGesture {
                        phraseSelected = phrase
                        print("tapped '\(phrase.phrase)'")
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
                    Spacer()
                    Text("No related phrases.")
                }
                Spacer()
            }
        }
        .background(colorBg)
    }
}

struct RelatedPhrases_Previews: PreviewProvider {
    static var previews: some View {
        RelatedPhrasesView(phraseSelected: .constant(Store().getPhrases(for: "just")!.first!))
    }
}
