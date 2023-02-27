//
//  WordsModelDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 24.12.2022.
//

import Foundation
import RealmSwift

final class WordsModelDB: Object {
    @objc dynamic private var id: Int = 0
    @objc dynamic private var foreignWord: String = .empty
    @objc dynamic private var nativeWord: String = .empty

    override public static func primaryKey() -> String? {
        return "id"
    }

    func getNonDBModel() throws -> WordsModelNonDB {
        guard isInvalidated == false else {
            throw DBError.objectInvalid
        }
        return .init(
            id: id,
            foreignWord: foreignWord,
            nativeWord: nativeWord)
    }

    convenience init(
        id: Int,
        foreignWord: String,
        nativeWord: String
    ) {
        self.init()
        self.id = id
        self.foreignWord = foreignWord
        self.nativeWord = nativeWord
    }

    convenience init(withModel model: WordsModelNonDB) {
        self.init()
        self.id = model.id
        self.foreignWord = model.foreignWord
        self.nativeWord = model.nativeWord
    }

}
