//
//  MainView.swift
//  Dictionary
//
//  Created by sdk on 29.12.2023.
//

import SwiftUI

enum ViewState {
    case left, general, right
}

struct MainView: View {
    let word: Word
    @Binding var word_: String
    @State var viewState: ViewState = .general
    @Binding var textSizes: Sizes
    
    @State private var wordTextField: String = ""
    @EnvironmentObject private var store: Store
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
                                    DefenitionView(textSize: $textSizes[index], definition: definition)
                                }
                            }
                        }
                        .padding([.top], geometry.safeAreaInsets.top)
                        
                        let widthSideView = geometry.size.width * 0.62
                        RelatedWordsView(relatedWords: relatedWords)
                            .offset(x: viewState == .left ? -(geometry.size.width - widthSideView) * 0.5 : -widthSideView - (geometry.size.width - widthSideView) * 0.5 )
                            .frame(width: widthSideView)
                            .opacity(viewState == .left ? 1 : 0)
                        RelatedPhrasesView(relatedPhrases: relatedPhrases)
                            .offset(x: viewState == .right ? (geometry.size.width - widthSideView) * 0.5 : widthSideView + (geometry.size.width - widthSideView) * 0.5)
                            .frame(width: widthSideView)
                            .opacity(viewState == .right ? 1 : 0)
                    }
                    .highPriorityGesture(DragGesture()
                        .onEnded({ value in
                            print(value.translation.width)
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
                        HStack {
                            TextField("Search English", text: $wordTextField)
                                .onSubmit({
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
            // every swiping at the ContentView causes _every_ MainView's 'init' calling TWICE
            // don't be lazy, check it: add 'init', compare with 'onAppear'
            relatedWords = word.relatedWordsIds?.compactMap({store.getWord(byID: $0)})
            relatedPhrases = store.getPhrases(for: word.id)

        }
        .onDisappear() {
            viewState = .general
        }
    }
}

struct MainView_Previews: PreviewProvider {
    struct MainView_: View {
        @State var textSize: Sizes
        let word: Word
        var body: some View {
            MainView(word: word, word_: .constant("just"), textSizes: $textSize).environmentObject(Store())
        }
    }
    
    @State var textSize: Sizes
    static var previews: some View {
        let word = Store().getWord(word: "just")!
        MainView_(textSize: sizes(for: word), word: word)
    }
    
    private static func sizes(for word: Word) -> Sizes {
        var sizes_ = Array<DefinitionSizes>()
        for d in word.definitions {
            var subExamples = Array<(CGSize, [CGSize])>(repeating: (.zero, []), count: d.subExamples.count)
            for subIndex in subExamples.indices {
                subExamples[subIndex].1 = Array<CGSize>(repeating: .zero, count: d.subExamples[subIndex].1.count)
            }
            sizes_.append((.zero, Array<CGSize>(repeating: .zero, count: d.examples.count), subExamples))
        }
        return sizes_
    }
}
