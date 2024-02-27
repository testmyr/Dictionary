//
//  WordView.swift
//  Dictionary
//
//  Created by sdk on 29.12.2023.
//

import SwiftUI

enum ViewState {
    case left, general, right
}

struct WordView: View {
    let word: Word
    @Binding var word_: String
    @Binding var relatedWord: Word
    @Binding var phraseSelected: Phrase?
    @State var viewState: ViewState = .general
    @Binding var textSizes: Sizes
    
    @EnvironmentObject private var store: Store
    @State private var wordTextField: String = ""
    @State private var relatedWords: [Word]?
    @State private var relatedPhrases: [Phrase]?
    private let dragTrigger: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                let heightBottom: CGFloat = 150
                VStack {
                    ZStack(alignment: .top) {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(0..<word.definitions.indices.count, id: \.self) { index in
                                    let definition = word.definitions[index]
                                    DefenitionView(textSize: $textSizes[index], definition: definition, tappedWord: $word_)
                                }
                            }
                        }
                        .padding([.top], geometry.safeAreaInsets.top)
                        
                        let widthSideView = geometry.size.width * 0.62
                        RelatedWordsView(releatedWordSelected: $relatedWord, relatedWords: relatedWords)
                            .offset(x: viewState == .left ? -(geometry.size.width - widthSideView) * 0.5 : -widthSideView - (geometry.size.width - widthSideView) * 0.5 )
                            .frame(width: widthSideView)
                            .opacity(viewState == .left ? 1 : 0)
                            .padding([.top], geometry.safeAreaInsets.top)
                        RelatedPhrasesView(phraseSelected: $phraseSelected, relatedPhrases: relatedPhrases)
                            .offset(x: viewState == .right ? (geometry.size.width - widthSideView) * 0.5 : widthSideView + (geometry.size.width - widthSideView) * 0.5)
                            .frame(width: widthSideView)
                            .opacity(viewState == .right ? 1 : 0)
                            .padding([.top], geometry.safeAreaInsets.top)
                    }
                    .highPriorityGesture(DragGesture()
                        .onEnded({ value in
                            withAnimation {
                                let translation = value.translation.width
                                if translation > dragTrigger {
                                    switch viewState {
                                    case .left:
                                        break
                                    case .general:
                                        viewState = .left
                                    case .right:
                                        viewState = .general
                                    }
                                } else if translation < -dragTrigger {
                                    switch viewState {
                                    case .left:
                                        viewState = .general
                                    case .general:
                                        viewState = .right
                                    case .right:
                                        break
                                    }
                                }
                            }
                        }))
                    VStack(alignment: .leading) {
                        HStack {
                            Button("Related words") {
                                withAnimation {
                                    viewState = .left
                                }
                            }
                            Spacer()
                            Button("Related phrases") {
                                withAnimation {
                                    viewState = .right
                                }
                            }
                        }
                        .padding([.top, .bottom])
                        HStack {
                            Text(word.partofspeech)
                            Spacer()
                            if let forms = word.forms {
                                Text(forms)
                            }
                        }
                        .font(.system(size: 14))
                        HStack {
                            TextField("Search English", text: $wordTextField)
                                .onSubmit({
                                    // remove trailing spaces from the entered text
                                    wordTextField = wordTextField.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
                                    word_ = wordTextField
                                })
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.none)
                            Button {
                                print("Clicked the speak button")
                            } label: {
                                Image(systemName: "speaker.3")
                            }
                            .tint(.black)
                        }
                        .padding([.bottom])
                    }
                    .frame(height: heightBottom)
                    .background(Color.white)
                }
                .onTapGesture {
                    withAnimation {
                        viewState = .general
                    }
                }
                .ignoresSafeArea(edges: [.top])
                .padding([.leading, .trailing], 5)
            }
        }
        .onAppear() {
            wordTextField = word_
            // it might be looking inefficient BUT
            // every swiping at the ContentView causes _every_ WordView's 'init' calling TWICE
            // don't be lazy, check it: add 'init', compare with 'onAppear'
            relatedWords = word.relatedWordsIds?.compactMap({store.getWord(byID: $0)})
            relatedPhrases = store.getPhrases(for: word.id)

        }
        .onDisappear() {
            viewState = .general
        }
    }
}

struct WordView_Previews: PreviewProvider {
    struct WordView_: View {
        @State var textSize: Sizes
        let word: Word
        var body: some View {
            WordView(word: word, word_: .constant("just"), relatedWord: .constant(Store().getWord(word: "just")!), phraseSelected: .constant(Store().getPhrases(for: "just")!.first!), textSizes: $textSize).environmentObject(Store())
        }
    }
    
    @State var textSize: Sizes
    static var previews: some View {
        let word = Store().getWord(word: "just")!
        WordView_(textSize: HistoryManager.sizes(for: word), word: word)
    }
}