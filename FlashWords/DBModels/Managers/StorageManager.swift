//
//  StorageManager.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 05.01.2023.
//

import Foundation
import RealmSwift

enum StorageManager {
    static func getFoldersItemsFromLocalStorage() -> [FoldersModelNonDB] {
        do {
            let realm = try Realm()
            let dataModels = realm.objects(FoldersModelDB.self)
            guard !dataModels.isInvalidated else {return []}
            return dataModels.map({ (try? $0.getNonDBModel()).nonOptional(.emptyModel) })
        } catch {
            return []
        }
    }

    static func setRewritingDataInLocalStorage(lists model: [FoldersModelNonDB]) {
        let dataModels = model.map({ $0.getDBModel() })

        do {
            let realm = try Realm()
            let oldObject = realm.objects(FoldersModelDB.self)
            realm.beginWrite()
            realm.delete(oldObject)
            realm.add(dataModels)
            try realm.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
    }
}
