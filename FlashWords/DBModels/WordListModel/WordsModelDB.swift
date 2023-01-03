//
//  WordsModelDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 24.12.2022.
//

import Foundation
import RealmSwift

final class WordsModelDB: Object {
    @objc dynamic private var foreignWord: String = .empty
    @objc dynamic private var nativeWord: String = .empty

    func getNonDBModel() throws -> WordsModelNonDB {
        guard isInvalidated == false else {
            throw DBError.objectInvalid
        }
        return .init(
            foreignWord: foreignWord,
            nativeWord: nativeWord)
    }

    convenience init(
       foreignWord: String,
        nativeWord: String
    ) {
        self.init()
        self.foreignWord = foreignWord
        self.nativeWord = nativeWord
    }

    convenience init(withModel model: WordsModelNonDB) {
        self.init()
        self.foreignWord = model.foreignWord
        self.nativeWord = model.nativeWord
    }

}
