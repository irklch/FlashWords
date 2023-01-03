//
//  ListsModelDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 03.01.2023.
//

import Foundation
import RealmSwift

final class ListsModelDB: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic private var listName: String = .empty
    private var wordsModel = List<WordsModelDB>()
    @objc dynamic private var isSelected: Bool = false

    func getNonDBModel() throws -> ListsModelNonDB {
        guard isInvalidated == false else {
            throw DBError.objectInvalid
        }
        return .init(
            id: id,
            listName: listName,
            wordsModel: wordsModel.map({ (try? $0.getNonDBModel()).nonOptional(.emptyModel) }),
            isSelected: isSelected)
    }

    convenience init(
        id: Int,
        listName: String,
        wordsModel: List<WordsModelDB>,
        isSelected: Bool
    ) {
        self.init()
        self.id = id
        self.listName = listName
        self.wordsModel = wordsModel
        self.isSelected = isSelected
    }

    convenience init(withModel model: ListsModelNonDB) {
        self.init()
        self.id = model.id
        self.listName = model.listName
        let wordsList = List<WordsModelDB>()
        model.wordsModel.forEach({ wordsList.append($0.getDBModel()) })
        self.wordsModel = wordsList
        self.isSelected = model.isSelected
    }

}
