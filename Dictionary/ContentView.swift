//
//  ContentView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var thing = ""
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    VStack {
                        ForEach(0..<10) { _ in
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.gray)
                                .frame(width: geometry.size.width, height: 250)
                        }
                    }
                }
                .padding([.top], geometry.safeAreaInsets.top)
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
                .padding()
            }
            .ignoresSafeArea(edges: [.top])
        }
        .padding([.leading, .trailing], 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
