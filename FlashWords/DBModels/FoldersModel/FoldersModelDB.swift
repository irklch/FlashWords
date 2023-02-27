//
//  FoldersModelDB.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 03.01.2023.
//

import Foundation
import RealmSwift

final class FoldersModelDB: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic private var folderName: String = .empty
    private var wordsModel = List<WordsModelDB>()
    @objc dynamic private var isSelected: Bool = false

    override public static func primaryKey() -> String? {
        return "id"
    }

    func getNonDBModel() throws -> FoldersModelNonDB {
        guard isInvalidated == false else {
            throw DBError.objectInvalid
        }
        return .init(
            id: id,
            folderName: folderName,
            wordsModel: wordsModel.map({ (try? $0.getNonDBModel()).nonOptional(.emptyModel) }),
            isSelected: isSelected)
    }

    convenience init(
        id: Int,
        folderName: String,
        wordsModel: List<WordsModelDB>,
        isSelected: Bool
    ) {
        self.init()
        self.id = id
        self.folderName = folderName
        self.wordsModel = wordsModel
        self.isSelected = isSelected
    }

    convenience init(withModel model: FoldersModelNonDB) {
        self.init()
        self.id = model.id
        self.folderName = model.folderName
        let wordsList = List<WordsModelDB>()
        model.wordsModel.forEach({ wordsList.append($0.getDBModel()) })
        self.wordsModel = wordsList
        self.isSelected = model.isSelected
    }

}
