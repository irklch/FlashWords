//
//  WordListCollectionViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 17.12.2022.
//

import Foundation
import RealmSwift
import Combine

final class WordListCollectionViewModel {
    @Published var mainThreadActionsState: MainThreadActionsState = .subscriptionAction
    var selectedListData: ListsModelNonDB
    let inputTextViewModel: NewWordInputViewModel

    private var listsData: [ListsModelNonDB]
    private var inputViewModelObserver: AnyCancellable?

    init() {
        self.inputTextViewModel = .init()
        self.listsData = Self.getListsDataItemsFromLocalStorage()
        self.selectedListData = listsData.first(where: { $0.isSelected }).nonOptional(.emptyModel)
        setupObserver()
    }

    private func setupObserver() {
        inputViewModelObserver = inputTextViewModel
            .$backgroundThreadActionsState
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] state in
                switch state {
                case .subscriptionAction:
                    break
                case .addedWord(let wordModel):
                    self?.setAddWord(wordModel)
                }
            }
    }

    private func setAddWord(_ model: WordsModelNonDB) {
        if listsData.count > 0,
           let listIndex = listsData.firstIndex(where: { $0.isSelected }) {
            listsData[listIndex].wordsModel.append(model)
            selectedListData = listsData[listIndex]
            Self.setWritingDataInLocalStorage(lists: listsData)
        } else {
            let listModel: ListsModelNonDB = .init(
                id: UUID().hashValue,
                listName: Titles.newListName,
                wordsModel: [model],
                isSelected: true)
            selectedListData = listModel
            Self.setWritingDataInLocalStorage(lists: [listModel])
        }
        mainThreadActionsState = .reloadData
    }

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

extension WordListCollectionViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case reloadData
    }
}
