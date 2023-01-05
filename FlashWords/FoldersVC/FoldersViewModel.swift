//
//  FoldersViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 05.01.2023.
//

import Foundation
import Combine

final class FoldersViewModel {
    @Published var mainThreadActionState: MainThreadActionsState = .subscriptionAction
    var foldersData: [FoldersModelNonDB]

    init() {
        self.foldersData = StorageManager.getFoldersItemsFromLocalStorage()
        if foldersData.count == 0 {
            let folderViewModel = FoldersModelNonDB(
                id: UUID().hashValue,
                folderName: Titles.allWords,
                wordsModel: [],
                isSelected: true)
            self.foldersData = [folderViewModel]
            StorageManager.setRewritingDataInLocalStorage(lists: [folderViewModel])
        }
    }

    func setSelectFolder(index: Int) {
        foldersData.forEach { $0.isSelected = false }
        foldersData[index].isSelected = true
        StorageManager.setRewritingDataInLocalStorage(lists: foldersData)
    }
}

extension FoldersViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case reloadData
    }
}
