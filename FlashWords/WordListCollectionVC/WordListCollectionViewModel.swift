//
//  WordListCollectionViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 17.12.2022.
//

import Foundation
import RealmSwift

struct WordListCollectionViewModel {
    private var listsData: [ListsModelNonDB] = []
    var selectedListData: ListsModelNonDB = .emptyModel
    var newWordModel: ListsModelNonDB = .emptyModel
    let inputTextViewModel: NewWordInputViewModel = .init()

    init() {
        self.listsData = Self.getListsDataItemsFromLocalStorage()
        self.selectedListData = listsData.first(where: { $0.isSelected }).nonOptional(.emptyModel)
    }

    
//    mutating func setWrite(word: WordListModelNonDB, listName: String) {
//        wordsData.append(word)
//        Self.setWritingDataInLocalStorage(model: <#T##[WordListModelNonDB]#>)
//    }

}

extension WordListCollectionViewModel {
    static func getListsDataItemsFromLocalStorage() -> [ListsModelNonDB] {
        do {
            let realm = try Realm()
            let dataModels = realm.objects(ListsModelDB.self)
            guard !dataModels.isInvalidated else {return []}
            return dataModels.map({ (try? $0.getNonDBModel()).nonOptional(.emptyModel) })
        } catch {
            return []
        }
    }

    static func setWritingDataInLocalStorage(lists model: [ListsModelNonDB]) {
        let dataModels = model.map({ $0.getDBModel() })

        do {
            let realm = try Realm()
            let oldObject = realm.objects(ListsModelDB.self)
            realm.beginWrite()
            realm.delete(oldObject)
            realm.add(dataModels)
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
}
