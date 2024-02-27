//
//  Phrase.swift
//  Dictionary
//
//  Created by sdk on 31.12.2023.
//

import Foundation
import SQLite

struct Phrase: Decodable, Definitionable, Equatable {
    static func == (lhs: Phrase, rhs: Phrase) -> Bool {
        lhs.phrase == rhs.phrase
    }
    
    let phrase: String
    var note: String? = nil
    var definitions: [Definition]
    
    var text: String { phrase }
    
    enum CodingKeys: String, CodingKey {
        case id, phrase, definitions = "main"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let phrase = try container.decode(String.self, forKey: .phrase)
        if phrase.contains("*") {
            let phraseNote = phrase.split(separator: "*")
            self.phrase = String(phraseNote[0])
            note = String(phraseNote[1])
        } else {
            self.phrase = phrase
        }
        let datadef = try! container.decode(Data.self, forKey: .definitions)
        let size = MemoryLayout<UInt8>.stride
        let length = datadef.count * MemoryLayout<UInt8>.stride
        var bytes = [UInt8](repeating: 0, count: datadef.count / size)
        (datadef as NSData).getBytes(&bytes, length: length)
        let definitions: [String] = String(decoding: bytes, as: UTF8.self).split(separator: "*").map { String($0) }
        self.definitions = definitions.map { definition in
            var examples: [String] = []
            let parts = definition.split(separator: "^")
            let meaning = String(parts[0])
            var subExamples: [(using: String, examples: [String])] = []
            var currentUsing: String?
            for part in parts.dropFirst(1) {
                if part.contains("~") {
                    currentUsing = String(part[part.firstIndex(of: "~")!...])
                    let example = String(part[..<part.firstIndex(of: "~")!])
                    subExamples.append((currentUsing!, examples: [example]))
                } else {
                    if let currentUsing {
                        let index = subExamples.firstIndex(where: {$0.using == currentUsing})!
                        subExamples[index].examples.append(String(part))
                    } else {
                        examples.append(String(part))
                    }
                }
            }
            return Definition(meaning: meaning, examples: examples, subExamples: subExamples)
        }
    }
}
