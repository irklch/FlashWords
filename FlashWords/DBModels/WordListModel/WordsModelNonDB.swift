//
//  WordsModelNonDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 24.12.2022.
//

import Foundation

struct WordsModelNonDB {
    static let emptyModel: WordsModelNonDB = .init(
        foreignWord: .empty,
        nativeWord: .empty)

    let foreignWord: String
    let nativeWord: String
#warning("добавить сюда изображение")
}

extension WordsModelNonDB {
    func getDBModel() -> WordsModelDB {
        return .init(
            foreignWord: foreignWord,
            nativeWord: nativeWord)
    }
}
