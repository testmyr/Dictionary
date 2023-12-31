//
//  Phrase.swift
//  Dictionary
//
//  Created by sdk on 31.12.2023.
//

import Foundation
import SQLite

struct Phrase: Decodable {
    let id: String
    let phrase: String
    var definitions: SQLite.Blob
    
    enum CodingKeys: String, CodingKey {
        case id, phrase, definitions = "main"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.phrase = try container.decode(String.self, forKey: .phrase)
        let datadef = try! container.decode(Data.self, forKey: .definitions)
        definitions = SQLite.Blob(data: datadef)
    }
}
