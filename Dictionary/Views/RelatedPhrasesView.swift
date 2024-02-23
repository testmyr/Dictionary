//
//  RelatedPhrasesView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct RelatedPhrasesView: View {
    private(set) var relatedPhrases: [Phrase]?

    var body: some View {
        GeometryReader { geometry in
            VStack() {
                if let relatedPhrases, relatedPhrases.count > 0 {
                    List(relatedPhrases, id: \.phrase) { phrase in
                        HStack {
                            Spacer()
                            Text("\(phrase.phrase)")
                                .rotationEffect(.degrees(180))
                                .onTapGesture {
                                    print("tapped phrase '\(phrase.phrase)'")
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
                    HStack {
                        Spacer()
                        Text("No related phrases.")
                    }
                    Spacer()
                }
            }
        }
        .background(Color.blue)
    }
}

struct RelatedPhrases_Previews: PreviewProvider {
    static var previews: some View {
        RelatedPhrasesView()
    }
}
