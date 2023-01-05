//
//  WordListTableViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 17.12.2022.
//

import Foundation
import RealmSwift
import Combine

final class WordListTableViewModel {
    @Published var mainThreadActionsState: MainThreadActionsState = .subscriptionAction
    var selectedFolderInfo: FoldersModelNonDB
    let inputTextViewModel: NewWordInputViewModel

    private var foldersInfo: [FoldersModelNonDB]
    private var inputViewModelObserver: AnyCancellable?

    init() {
        self.inputTextViewModel = .init()
        self.foldersInfo = Self.getFoldersItemsFromLocalStorage()
        self.selectedFolderInfo = foldersInfo.first(where: { $0.isSelected }).nonOptional(.emptyModel)
        setupObserver()
    }

    func setDeleteItemWith(index: Int) {
        selectedFolderInfo.wordsModel.remove(at: index)
        Self.setWritingDataInLocalStorage(lists: foldersInfo)
        mainThreadActionsState = .reloadData
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
        if foldersInfo.count > 0 {
            selectedFolderInfo.wordsModel.append(model)
            Self.setWritingDataInLocalStorage(lists: foldersInfo)
        } else {
            let folderModel: FoldersModelNonDB = .init(
                id: UUID().hashValue,
                folderName: Titles.allWords,
                wordsModel: [model],
                isSelected: true)
            selectedFolderInfo = folderModel
            Self.setWritingDataInLocalStorage(lists: [folderModel])
        }
        mainThreadActionsState = .reloadData
    }

}

extension WordListTableViewModel {
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

    static func setWritingDataInLocalStorage(lists model: [FoldersModelNonDB]) {
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

extension WordListTableViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case reloadData
    }
}
