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
    
    @State var textSizes: [(CGSize, [CGSize], [(CGSize, [CGSize])])]
    
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
                                    VStack(alignment: .leading) {
                                        // the meaning
                                        TextWordedView(words: definition.meaning.split(separator: " ").map({String($0)}), childrenSize: $textSizes[index].0)
                                            .frame(height: textSizes[index].0.height + 10)
                                        // its examples
                                        ForEach(0..<definition.examples.indices.count, id: \.self) { indexExmpl in
                                            TextWordedView(words: ["• "] +  definition.examples[indexExmpl].split(separator: " ").map({String($0)}), childrenSize: $textSizes[index].1[indexExmpl])
                                                .frame(height: textSizes[index].1[indexExmpl].height)
                                        }
                                        // and subexamples
                                        let subExamples = definition.subExamples
                                        ForEach(0..<subExamples.indices.count, id: \.self) { index2 in
                                            VStack {
                                                Divider()
                                                    .frame(height: 1)
                                                    .overlay(.black.opacity(0.2))
                                                TextWordedView(words: subExamples[index2].0.split(separator: " ").map({String($0)}), childrenSize: $textSizes[index].2[index2].0)
                                                    .frame(height: textSizes[index].2[index2].0.height)
                                                    .font(.callout)
                                                
                                                let examples = subExamples[index2].examples
                                                ForEach(0..<examples.indices.count, id: \.self) { index3 in
                                                    TextWordedView(words: ["  •"] + examples[index3].split(separator: " ").map({String($0)}), childrenSize: $textSizes[index].2[index2].1[index3])
                                                        .frame(height: textSizes[index].2[index2].1[index3].height)
                                                }
                                            }
                                        }
                                        .padding([.bottom], 10)
                                    }
                                    .padding()
                                    .background(.red.opacity(0.5))
                                    .cornerRadius(20)
                                }
                            }
                        }
                        .padding([.top], geometry.safeAreaInsets.top)
                        
                        let widthSideView = geometry.size.width * 0.62
                        RelatedWordsView()
                            .offset(x: viewState == .left ? -(geometry.size.width - widthSideView) * 0.5 : -widthSideView - (geometry.size.width - widthSideView) * 0.5 )
                            .frame(width: widthSideView)
                            .opacity(viewState == .left ? 1 : 0)
                        RelatedPhrasesView()
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
                    VStack {
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
                        .padding()
                        HStack {
                            TextField("Search English", text: $word_)
                                .textFieldStyle(.roundedBorder)
                            Button {
                                print("Clicked the speak button")
                            } label: {
                                Image(systemName: "speaker.3")
                            }
                            .tint(.black)
                        }
                        .padding([.top, .bottom])
                    }
                    //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    //                    .contentShape(Rectangle())
                    //                    .simultaneousGesture(DragGesture())
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
        .onDisappear() {
            viewState = .general
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let word = Store().getWord(word: "just")!
        MainView(word: word, word_: .constant("just"), textSizes: sizes(for: word)).environmentObject(Store())
    }
    
    private static func sizes(for word: Word) -> [(CGSize, [CGSize], [(CGSize, [CGSize])])] {
        var sizes_ = Array<(CGSize, [CGSize], [(CGSize, [CGSize])])>()
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
