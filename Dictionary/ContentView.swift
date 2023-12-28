//
//  ContentView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

enum ViewState {
    case left, general, right
}

struct ContentView: View {
    @StateObject private var store = Store()
    @State private var thing = ""
    
    @State var viewState: ViewState = .general
    
    var body: some View {
        let dragTrigger: CGFloat = 50
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                let heightBottom: CGFloat = 150
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            ForEach(store.definitions, id: \.self) { definition in
                                Text(definition)
                                    .padding()
                                    .background(.red)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding([.top], geometry.safeAreaInsets.top)
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
                            TextField("Search English", text: $thing)
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
                    .frame(height: heightBottom)
                    .background(Color.white)
                    .onTapGesture {
                        withAnimation {
                            viewState = .general
                        }
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
                }
                .ignoresSafeArea(edges: [.top])
                .padding([.leading, .trailing], 5)
                let widthSideView = geometry.size.width * 0.62
                let heightSideView = geometry.size.height - heightBottom
                RelatedWordsView()
                    .offset(x: viewState == .left ? 0 : -widthSideView)
                    .frame(width: widthSideView, height: heightSideView)
                RelatedPhrasesView()
                    .offset(x: viewState == .right ? geometry.size.width - widthSideView : geometry.size.width)
                    .frame(width: widthSideView, height: heightSideView)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
