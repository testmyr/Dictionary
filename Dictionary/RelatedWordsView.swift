//
//  RelatedWordsView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct RelatedWordsView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Spacer()
                Text("Hello, RelatedWords!")
                Spacer()
            }
        }
        .background(Color.green)
    }
}

struct RelatedWords_Previews: PreviewProvider {
    static var previews: some View {
        RelatedWordsView()
    }
}
