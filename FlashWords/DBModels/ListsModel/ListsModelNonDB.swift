//
//  ListsModelNonDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 03.01.2023.
//

import Foundation
import RealmSwift

struct ListsModelNonDB {
    static let emptyModel: ListsModelNonDB = .init(
        id: 0,
        listName: .empty,
        wordsModel: [],
        isSelected: false)

    let id: Int
    let listName: String
    let wordsModel: [WordsModelNonDB]
    let isSelected: Bool
}

extension ListsModelNonDB {
    func getDBModel() -> ListsModelDB {
        let wordsList = List<WordsModelDB>()
        wordsModel.forEach({ wordsList.append($0.getDBModel()) })
        return .init(
            id: id,
            listName: listName,
            wordsModel: wordsList,
            isSelected: isSelected)
    }
}
