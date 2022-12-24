//
//  WordListModelDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 24.12.2022.
//

import Foundation
import RealmSwift

final class WordListModelDB: Object {
    @objc dynamic private var englishWord: String = .empty
    @objc dynamic private var russianWord: String = .empty


    func getNonDBModel() throws -> WordListModelNonDB {
        guard isInvalidated == false else {
            throw DBError.objectInvalid
        }
        return .init(
            englishWord: englishWord,
            russianWord: russianWord)
    }

    convenience init(
        englishWord: String,
        russianWord: String
    ) {
        self.init()
        self.englishWord = englishWord
        self.russianWord = russianWord
    }

    convenience init(withModel model: WordListModelNonDB) {
        self.init()
        self.englishWord = model.englishWord
        self.russianWord = model.russianWord
    }

}
