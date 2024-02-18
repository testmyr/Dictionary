//
//  TextWordedView.swift
//  Dictionary
//
//  Created by sdk on 02.01.2024.
//

import SwiftUI

struct TextWordedView: View {
    var words : [String]
    @Binding var childrenSize: CGSize
    
    var body : some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ForEach(0..<self.words.count, id: \.self) { i in
                    Text(self.words[i])
                        .padding([.horizontal], 4)
                        .padding([.vertical], 1)
                        .onTapGesture {
                            print("tapped '\(self.words[i])'")
                        }
                        .alignmentGuide(.leading, computeValue: { context in
                            if (abs(width - context.width) > geometry.size.width)
                            {
                                width = 0
                                height -= context.height
                            }
                            let result = width
                            if i < self.words.count-1 {
                                width -= context.width
                            } else {
                                width = 0
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: { _ in
                            let result = height
                            if i >= self.words.count - 1 {
                                height = 0
                            }
                            return result
                        })
                }
            }
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: GeometrySizePreferenceKey.self, value: geometry.size)
                        .onPreferenceChange(GeometrySizePreferenceKey.self) { geometrySize in
                            childrenSize = geometrySize
                        }
                }
            }
        }
    }
    
    struct GeometrySizePreferenceKey: PreferenceKey {
        static var defaultValue: CGSize = .zero
        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
}

struct TextViewWorded_Previews: PreviewProvider {
    static var previews: some View {
        TextWordedView(words: Store().simulatedDefenitions()[0], childrenSize: .constant(.zero))
    }
}
