//
//  RelatedWordsView.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import SwiftUI

struct RelatedWordsView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Spacer()
                Text("Hello, RelatedWords!")
                Spacer()
            }
        }
        .background(Color.green)
    }
    
    
    // just playing with :-|
//    var body: some View {
//        VStack(alignment:.leading) {
//            rectangle // Rectangle1
//                .alignmentGuide(.leading, computeValue: { viewDimensions in
//                    let leading = viewDimensions[.leading] // As the explicit value is nil at this time, the value of leading is 0
//                    return viewDimensions.width * 1 // Set the explicit value of leading to one third of the width
//                })
//            rectangle2 // Rectangle2
//            rectangle2
//        }
//        .border(.pink)
//    }
//
//    var rectangle:some View {
//        Rectangle()
//            .fill(.blue.gradient)
//            .frame(width: 100, height: 100)
//    }
//    var rectangle2:some View {
//        Rectangle()
//            .fill(.blue.gradient)
//            .frame(width: 200, height: 100)
//    }
}

struct RelatedWords_Previews: PreviewProvider {
    static var previews: some View {
        RelatedWordsView()
    }
}
