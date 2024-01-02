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
    @Binding var word: String
    var definitions: [[String]]
    @State var viewState: ViewState = .general
    @State var textSizes: [CGSize]
    
    private let dragTrigger: CGFloat = 50
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                let heightBottom: CGFloat = 150
                VStack {
                    ZStack(alignment: .top) {
                        ScrollView(showsIndicators: false) {
                            VStack {
                                ForEach(0..<definitions.indices.count, id: \.self) { index in
                                    TextWordedView(words: definitions[index], childrenSize: $textSizes[index])
                                        .padding()
                                        .background(.red)
                                        .cornerRadius(20)
                                        .frame(height: textSizes[index].height + 30)
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
                    .gesture(DragGesture()
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
                            TextField("Search English", text: $word)
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
        let temp = Store().definitions_
        MainView(word: .constant("do1"), definitions: Store().definitions_, textSizes: Array<CGSize>(repeating: .zero, count: temp.count)).environmentObject(Store())
    }
}
