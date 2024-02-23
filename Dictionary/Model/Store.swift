//
//  Store.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import Foundation
import SQLite

class Store: ObservableObject {
    @Published var definitions_: [[String]] = []
    
    private let db: Connection?
    private let users = Table("dictionary")
    private let phrases = Table("phrases")
    
    private let id = Expression<String>("id")
    private let wordExpression = Expression<String>("word")
    private let definitions = Expression<SQLite.Blob>("main")
    private let partofspeech = Expression<String>("partofspeech")
    private let relatedwords = Expression<String>("relatedwords")
    private let forms = Expression<String>("forms")
    private let phrase = Expression<String>("phrase")
    
    init() {
        let path = Bundle.main.path(forResource: "Dict_demo", ofType: "sqlite3")!
        db = try? Connection(path, readonly: true)
        
        if let user = try? db?.pluck(users) {
        }
        let temp2 = getPhrases(for: "just")
        let temp = getWord(word: "just")
        let r = temp!.definitions    }
    
    func getWord(word: String) -> Word? {
        let query = users.select(id, wordExpression, partofspeech, definitions, relatedwords, forms)
            .filter(self.wordExpression == word)
            .limit(1)
        if let element = try? db?.prepareRowIterator(query).next() {
            let decoder = element.decoder()
            return try? Word(from: decoder)
        } else {
            return nil
        }
    }
    func getWord(byID id: String) -> Word? {
        let query = users.select(self.id, wordExpression, partofspeech, definitions, relatedwords, forms)
            .filter(self.id == id)
            .limit(1)
        if let element = try? db?.prepareRowIterator(query).next() {
            let decoder = element.decoder()
            return try? Word(from: decoder)
        } else {
            return nil
        }
    }
    
    func getPhrases(for wordID: String) -> [Phrase]? {
        let queryPhrases = phrases.select(id, phrase, definitions)
            .filter(self.id == wordID)
        let mapRowIterator = try? db?.prepareRowIterator(queryPhrases)
        return try? mapRowIterator?.compactMap{ try? Phrase(from: $0.decoder()) }
    }
    
    func simulatedDefenitions() -> [[String]] {
        var definitions_: [[String]] = []
        for _ in 2...10 {
            var definition: [String] = []
            for _ in 0...Int.random(in: 10...50) {
                let wordLength = Int.random(in: 1...10)
                definition.append(String(Array<Character>(repeating: "A", count: wordLength)))
            }
            definitions_.append(definition)
        }
        return definitions_
    }
    
    
    // TODO in case of editing
//    private func copyDatabaseIfNeeded(sourcePath: String) -> Bool {
//        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//        let destinationPath = documents + "/Dict_trial.sqlite3"
//        print(destinationPath)
//        let exists = FileManager.default.fileExists(atPath: destinationPath)
//        guard !exists else { return false }
//        do {
//            try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
//            return true
//        } catch {
//            print("error during file copy: \(error)")
//            return false
//        }
//    }
}
