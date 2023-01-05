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

    func setUpdateData() {
        foldersData = StorageManager.getFoldersItemsFromLocalStorage()
    }

    func setSelectFolder(index: Int) {
        foldersData.forEach { $0.isSelected = false }
        foldersData[index].isSelected = true
        StorageManager.setRewritingDataInLocalStorage(lists: foldersData)
    }

    func setSaveNewFolder(name: String) {
        let newFolder: FoldersModelNonDB = .init(
            id: UUID().hashValue,
            folderName: name,
            wordsModel: [],
            isSelected: false)
        foldersData.append(newFolder)
        StorageManager.setRewritingDataInLocalStorage(lists: foldersData)
        mainThreadActionState = .reloadData
    }

    func setDeleteFolder(index: Int) {
        foldersData.remove(at: index)
        foldersData.first?.isSelected = true
        StorageManager.setRewritingDataInLocalStorage(lists: foldersData)
        mainThreadActionState = .reloadData
    }
}

extension FoldersViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case reloadData
    }
}
