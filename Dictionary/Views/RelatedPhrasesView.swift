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
                Spacer()
                if let relatedPhrases, relatedPhrases.count > 0 {
                    List(relatedPhrases, id: \.phrase) { phrase in
                        Text("\(phrase.phrase)")
                        .onTapGesture {
                            print("tapped phrase '\(phrase.phrase)'")
                        }
                    }
                    .padding([.top], 5)
                } else {
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
