//
//  WordsModelNonDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 24.12.2022.
//

import Foundation

struct WordsModelNonDB {
    static let emptyModel: WordsModelNonDB = .init(
        id: 0,
        foreignWord: .empty,
        nativeWord: .empty)

    let id: Int
    let foreignWord: String
    let nativeWord: String
}

extension WordsModelNonDB {
    func getDBModel() -> WordsModelDB {
        return .init(
            id: id,
            foreignWord: foreignWord,
            nativeWord: nativeWord)
    }
}
