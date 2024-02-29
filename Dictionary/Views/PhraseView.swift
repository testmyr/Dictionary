//
//  PhraseView.swift
//  Dictionary
//
//  Created by sdk on 27.02.2024.
//

import SwiftUI

struct PhraseView: View {
    let phrase: Phrase
    
    @Binding var word_: String
    @Binding var textSizes: Sizes
    
    init(phrase: Phrase, index: Int, history: HistoryManager) {
        self.phrase = phrase
        _word_ = history.bindingToWord(forIndex: index)
        _textSizes = history.bindingToSizes(forIndex: index)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                VStack {
                    ZStack(alignment: .top) {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(0..<phrase.definitions.indices.count, id: \.self) { index in
                                    let definition = phrase.definitions[index]
                                    DefenitionView(definition: definition, textSize: $textSizes[index], tappedWord: $word_)
                                        .rotationEffect(.degrees(180))
                                }
                            }
                        }
                        .rotationEffect(.degrees(180))
                        .padding([.top], geometry.safeAreaInsets.top)
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text("phrase")
                            Spacer()
                            Text(phrase.note ?? "")
                        }
                        .padding([.top], 15)
                        .font(.system(size: 15))
                        HStack {
                            Text(phrase.phrase)
                                .font(.system(size: 20))
                                .padding([.leading, .trailing], 10)
                            Spacer()
                        }
                        .padding([.top, .bottom], 10)
                        .background(.green.opacity(0.5))
                        .cornerRadius(10)
                        .frame(minHeight: 50)
                        Spacer()
                    }
                    .frame(height: heightBottom)
                    .background(Color.white)
                }
                .ignoresSafeArea(edges: [.top])
                .padding([.leading, .trailing], 5)
            }
        }
    }
}

struct PhraseView_Previews: PreviewProvider {
    struct PhraseView_: View {
        @State var textSize: Sizes
        let phrase: Phrase
        var body: some View {
            PhraseView(phrase: phrase, index: 0, history: HistoryManager(), textSizes: $textSize).environmentObject(Store())
        }
    }

    @State var textSize: Sizes
    static var previews: some View {
        let phrase = Store().getPhrases(for: "just")!.first!
        PhraseView_(textSize: HistoryManager.sizes(for: phrase), phrase: phrase)
    }
}
fileprivate extension PhraseView {
    init(phrase: Phrase, index: Int, history: HistoryManager, textSizes: Binding<Sizes>) {
        self.init(phrase: phrase, index: index, history: history)
        self._textSizes = textSizes
    }
}

