//
//  Word.swift
//  Dictionary
//
//  Created by sdk on 29.12.2023.
//

import Foundation
import SQLite

// TODO rm
struct Word: Identifiable, Hashable {
    let id = UUID()
    var word: String
}

struct Word1: Decodable {
    let id: String
    let word: String
    var definitions: SQLite.Blob
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
        definitions = SQLite.Blob(data: datadef)
        self.partofspeech = try container.decode(String.self, forKey: .partofspeech)
        self.relatedwords = try container.decode(String.self, forKey: .relatedwords)
        self.forms = try? container.decode(String.self, forKey: .forms)
    }
}
