//
//  DefenitionView.swift
//  Dictionary
//
//  Created by sdk on 09.01.2024.
//

import SwiftUI

struct DefenitionView: View {
    let definition: Definition
    
    @Binding var textSize: DefinitionSizes
    @Binding var tappedWord: String
    
    var body: some View {
        VStack(alignment: .leading) {
            // the meaning
            TextWordedView(words: definition.meaning.split(separator: " ").map({String($0)}), childrenSize: $textSize.0, tappedWord: $tappedWord)
                .frame(height: textSize.0.height + 10)
            // its examples
            ForEach(0..<definition.examples.indices.count, id: \.self) { indexExmpl in
                TextWordedView(words: ["•"] +  definition.examples[indexExmpl].split(separator: " ").map({String($0)}), childrenSize: $textSize.1[indexExmpl], tappedWord: $tappedWord)
                    .frame(height: textSize.1[indexExmpl].height)
            }
            // and subexamples
            let subExamples = definition.subExamples
            ForEach(0..<subExamples.indices.count, id: \.self) { index2 in
                VStack {
                    Divider()
                        .frame(height: 1)
                        .overlay(.black.opacity(0.2))
                    TextWordedView(words: subExamples[index2].0.split(separator: " ").map({String($0)}), childrenSize: $textSize.2[index2].0, tappedWord: $tappedWord)
                        .frame(height: textSize.2[index2].0.height)
                        .font(.callout)
                    
                    let examples = subExamples[index2].examples
                    ForEach(0..<examples.indices.count, id: \.self) { index3 in
                        TextWordedView(words: ["  •"] + examples[index3].split(separator: " ").map({String($0)}), childrenSize: $textSize.2[index2].1[index3], tappedWord: $tappedWord)
                            .frame(height: textSize.2[index2].1[index3].height)
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

struct DefenitionView_Previews: PreviewProvider {
    struct DefenitionView_: View {
        @Binding var tappedWord: String
        @State var textSize: DefinitionSizes
        let def = Store().getWord(word: "just")!.definitions[0]
        var body: some View {
            VStack {
                DefenitionView(definition: def, textSize: $textSize, tappedWord: $tappedWord)
                Spacer()
            }
        }
    }

    static var previews: some View {
        let def = Store().getWord(word: "just")!.definitions[0]
        DefenitionView_(tappedWord: .constant(""), textSize: sizes(for: def))
    }

    private static func sizes(for def: Definition) -> DefinitionSizes {
        var subExamples = Array<(CGSize, [CGSize])>(repeating: (.zero, []), count: def.subExamples.count)
        for subIndex in subExamples.indices {
            subExamples[subIndex].1 = Array<CGSize>(repeating: .zero, count: def.subExamples[subIndex].1.count)
        }
        return (.zero, Array<CGSize>(repeating: .zero, count: def.examples.count), subExamples)
    }
}
