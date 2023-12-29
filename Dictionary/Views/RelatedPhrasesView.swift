//
//  RelatedPhrasesView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct RelatedPhrasesView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Spacer()
                HStack {
                    Spacer()
                    Text("Hello, RelatedPhrases!")
                }
                Spacer()
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
