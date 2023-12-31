//
//  Store.swift
//  Dictionary
//
//  Created by sdk on 28.12.2023.
//

import Foundation
import SQLite

class Store: ObservableObject {
    @Published var definitions_: [String] = []
    
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
        let path = Bundle.main.path(forResource: "Dict_trial", ofType: "sqlite3")!
        db = try? Connection(path, readonly: true)
        
        if let user = try? db?.pluck(users) {
        }
        let temp = getWord(word: "just")
        let temp2 = getPhrase(for: "just")
        print(String(decoding: temp!.definitions.bytes, as: UTF8.self))
        print(String(decoding: temp2!.definitions.bytes, as: UTF8.self))
#if DEBUG
        simulateData()
#endif
    }
    
    func getWord(word: String) -> Word1? {
        let query = users.select(id, wordExpression, partofspeech, definitions, relatedwords, forms)
            .filter(self.wordExpression == word)
            .limit(1)
        if let element = try? db?.prepareRowIterator(query).next() {
            let decoder = element.decoder()
            return try? Word1(from: decoder)
        } else {
            return nil
        }
    }
    func getWord(byID id: String) {
    }
    
    func getPhrase(for wordID: String) -> Phrase? {
        let queryPhrases = phrases.select(id, phrase, definitions)
            .filter(self.id == wordID)
            .limit(1)
        if let element = try? db?.prepareRowIterator(queryPhrases).next() {
            let decoder = element.decoder()
            return try? Phrase(from: decoder)
        } else {
            return nil
        }
    }
    
    func simulateData() {
        for _ in 0...10 {
            let r = Int.random(in: 50...400)
            let definition = String(Array<Character>(repeating: "A", count: r))
            definitions_.append(definition)
        }
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
