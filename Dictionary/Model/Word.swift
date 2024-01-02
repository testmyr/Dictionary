//
//  Word.swift
//  Dictionary
//
//  Created by sdk on 29.12.2023.
//

import Foundation
import SQLite

// TODO rm
struct Word_: Identifiable, Hashable {
    let id = UUID()
    var word: String
}

struct Definition {
    var meaning: String
    var examples: [String]
    var subExamples: [(using: String, examples: [String])]
}

struct Word: Decodable {
    let id: String
    let word: String
    let partofspeech: String
    let relatedwords: String
    let forms: String?
    
    var definitions: [Definition] {
        let definitions: [String] = String(decoding: definitions_.bytes, as: UTF8.self).split(separator: "*").map { String($0) }
        var definitionsWords = [[String]]()
        return definitions.map { definition in
            var examples: [String] = []
            let parts = definition.split(separator: "^")
            let meaning = String(parts[0])
            var subExamples: [(using: String, examples: [String])] = []
            var currentUsing: String?
            for part in parts.dropFirst(1) {
                if part.contains("~") {
                    currentUsing = part.substring(from: part.firstIndex(of: "~")!)
                    let example = String(part.substring(to: part.firstIndex(of: "~")!))
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
    
    private var definitions_: SQLite.Blob
    
    enum CodingKeys: String, CodingKey {
        case id, word, definitions = "main", partofspeech, relatedwords, forms
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.word = try container.decode(String.self, forKey: .word)
        let datadef = try! container.decode(Data.self, forKey: .definitions)
        definitions_ = SQLite.Blob(data: datadef)
        self.partofspeech = try container.decode(String.self, forKey: .partofspeech)
        self.relatedwords = try container.decode(String.self, forKey: .relatedwords)
        self.forms = try? container.decode(String.self, forKey: .forms)
    }
}
