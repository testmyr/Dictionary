//
//  DefenitionView.swift
//  Dictionary
//
//  Created by sdk on 09.01.2024.
//

import SwiftUI

struct DefenitionView: View {
    @Binding var textSize: (CGSize, [CGSize], [(CGSize, [CGSize])])
    
    let definition: Definition
    
    var body: some View {
        VStack(alignment: .leading) {
            // the meaning
            TextWordedView(words: definition.meaning.split(separator: " ").map({String($0)}), childrenSize: $textSize.0)
                .frame(height: textSize.0.height + 10)
            // its examples
            ForEach(0..<definition.examples.indices.count, id: \.self) { indexExmpl in
                TextWordedView(words: ["•"] +  definition.examples[indexExmpl].split(separator: " ").map({String($0)}), childrenSize: $textSize.1[indexExmpl])
                    .frame(height: textSize.1[indexExmpl].height)
            }
            // and subexamples
            let subExamples = definition.subExamples
            ForEach(0..<subExamples.indices.count, id: \.self) { index2 in
                VStack {
                    Divider()
                        .frame(height: 1)
                        .overlay(.black.opacity(0.2))
                    TextWordedView(words: subExamples[index2].0.split(separator: " ").map({String($0)}), childrenSize: $textSize.2[index2].0)
                        .frame(height: textSize.2[index2].0.height)
                        .font(.callout)
                    
                    let examples = subExamples[index2].examples
                    ForEach(0..<examples.indices.count, id: \.self) { index3 in
                        TextWordedView(words: ["  •"] + examples[index3].split(separator: " ").map({String($0)}), childrenSize: $textSize.2[index2].1[index3])
                            .frame(height: textSize.2[index2].1[index3].height)
                    }
                }
            }
            .padding([.bottom], 10)
        }
    }
}

struct DefenitionView_Previews: PreviewProvider {
    struct DefenitionView_: View {
        let def = Store().getWord(word: "just")!.definitions[0]
        @State var textSize: (CGSize, [CGSize], [(CGSize, [CGSize])])
        var body: some View {
            VStack {
                DefenitionView(textSize: $textSize, definition: def)
                Spacer()
            }
        }
    }

    static var previews: some View {
        let def = Store().getWord(word: "just")!.definitions[0]
        DefenitionView_(textSize: sizes(for: def))
    }

    private static func sizes(for def: Definition) -> (CGSize, [CGSize], [(CGSize, [CGSize])]) {
        var subExamples = Array<(CGSize, [CGSize])>(repeating: (.zero, []), count: def.subExamples.count)
        let _ = print(subExamples.count)
        for subIndex in subExamples.indices {
            subExamples[subIndex].1 = Array<CGSize>(repeating: .zero, count: def.subExamples[subIndex].1.count)
        }
        return (.zero, Array<CGSize>(repeating: .zero, count: def.examples.count), subExamples)
    }
}
