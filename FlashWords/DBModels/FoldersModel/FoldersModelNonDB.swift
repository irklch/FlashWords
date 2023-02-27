//
//  FoldersModelNonDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 03.01.2023.
//

import Foundation
import RealmSwift

final class FoldersModelNonDB {
    static let emptyModel: FoldersModelNonDB = .init(
        id: 0,
        folderName: .empty,
        wordsModel: [],
        isSelected: false)

    let id: Int
    var folderName: String
    var wordsModel: [WordsModelNonDB]
    var isSelected: Bool

    init(
        id: Int,
        folderName: String,
        wordsModel: [WordsModelNonDB],
        isSelected: Bool
    ) {
        self.id = id
        self.folderName = folderName
        self.wordsModel = wordsModel
        self.isSelected = isSelected
    }
}

extension FoldersModelNonDB {
    func getDBModel() -> FoldersModelDB {
        let wordsList = List<WordsModelDB>()
        wordsModel.forEach({ wordsList.append($0.getDBModel()) })
        return .init(
            id: id,
            folderName: folderName,
            wordsModel: wordsList,
            isSelected: isSelected)
    }
}
