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
        self.foldersInfo = StorageManager.getFoldersItemsFromLocalStorage()
        self.selectedFolderInfo = foldersInfo.first(where: { $0.isSelected }).nonOptional(.emptyModel)
        setupObserver()
    }

    func setDeleteItemWith(index: Int) {
        selectedFolderInfo.wordsModel.remove(at: index)
        StorageManager.setRewritingDataInLocalStorage(lists: foldersInfo)
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
        StorageManager.setRewritingDataInLocalStorage(lists: foldersInfo)
        mainThreadActionsState = .reloadData
    }

}

extension WordListTableViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case reloadData
    }
}
