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
    var isAllWordsFolder: Bool

    var allFoldersInfo: [FoldersModelNonDB]
    private var inputViewModelObserver: AnyCancellable?

    init() {
        self.inputTextViewModel = .init()
        self.allFoldersInfo = StorageManager.getFoldersItemsFromLocalStorage()
        if let selectedFolderInfo = allFoldersInfo.first(where: { $0.isSelected }) {
            self.selectedFolderInfo = selectedFolderInfo
            self.isAllWordsFolder = false
        } else {
            self.selectedFolderInfo = .emptyModel
            self.isAllWordsFolder = true
        }
        setupObserver()
    }

    func setDeleteItemWith(indexPath: IndexPath) {
        if isAllWordsFolder {
            allFoldersInfo[indexPath.section].wordsModel.remove(at: indexPath.row)
        } else {
            selectedFolderInfo.wordsModel.remove(at: indexPath.row)
        }
        StorageManager.setRewritingDataInLocalStorage(lists: allFoldersInfo)
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
        selectedFolderInfo.wordsModel.append(model)
        StorageManager.setRewritingDataInLocalStorage(lists: allFoldersInfo)
        mainThreadActionsState = .reloadData
    }

    func setDeselectFolder() {
        if !isAllWordsFolder {
            selectedFolderInfo.isSelected = false
            StorageManager.setRewritingDataInLocalStorage(lists: allFoldersInfo)
        }
    }

    func setUpdateData() {
        self.allFoldersInfo = StorageManager.getFoldersItemsFromLocalStorage()
        if let selectedFolderInfo = allFoldersInfo.first(where: { $0.isSelected }) {
            self.selectedFolderInfo = selectedFolderInfo
            self.isAllWordsFolder = false
        } else {
            self.selectedFolderInfo = .emptyModel
            self.isAllWordsFolder = true
        }
        mainThreadActionsState = .reloadData
    }

}

extension WordListTableViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case reloadData
    }
}
