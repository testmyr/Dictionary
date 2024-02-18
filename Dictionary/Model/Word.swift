//
//  Word.swift
//  Dictionary
//
//  Created by sdk on 29.12.2023.
//

import Foundation
import SQLite

struct Definition {
    var meaning: String
    var examples: [String]
    var subExamples: [(using: String, examples: [String])]
}

struct Word: Decodable {
    let id: String
    let word: String
    var definitions: [Definition]
    let partofspeech: String
    let relatedwords: String
    let forms: String?
    
    enum CodingKeys: String, CodingKey {
        case id, word, definitions = "main", partofspeech, relatedwords, forms
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.word = try container.decode(String.self, forKey: .word)
        
        let datadef = try! container.decode(Data.self, forKey: .definitions)
        //let definitions_ = SQLite.Blob(data: datadef)
        //let definitions: [String] = String(decoding: definitions_.bytes, as: UTF8.self).split(separator: "*").map { String($0) }
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
        
        self.partofspeech = try container.decode(String.self, forKey: .partofspeech)
        self.relatedwords = try container.decode(String.self, forKey: .relatedwords)
        self.forms = try? container.decode(String.self, forKey: .forms)
    }
}
