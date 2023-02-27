//
//  FoldersTableViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 05.01.2023.
//

import Foundation
import Combine
import SwiftExtension

final class FoldersTableViewModel {
    @Published var mainThreadActionState: MainThreadActionsState = .subscriptionAction
    var cellsViewModel: [FolderTableViewCellViewModel]
    var isEditingMode: Bool = false
    let isMovingMode: Bool
    let title: String
    let movingFromFolderId: Int?
    let movingWordId: Int?

    private var foldersData: [FoldersModelNonDB]
    private let observersManager = AnyCancellableManager<Observers>()

    init(
        title: String,
        isMovingMode: Bool,
        movingFromFolderId: Int? = nil,
        movingWordId: Int? = nil
    ) {
        self.title = title
        self.isMovingMode = isMovingMode
        self.movingFromFolderId = movingFromFolderId
        self.movingWordId = movingWordId
        self.foldersData = StorageManager.getFoldersItemsFromLocalStorage()
        self.cellsViewModel = foldersData.map({ FolderTableViewCellViewModel(
            name: $0.folderName,
            wordsCount: $0.wordsModel.count)
        })
        setupCellsObservers()
    }

    private func setupCellsObservers() {
        var observers: [AnyCancellable] = []
        cellsViewModel.enumerated().forEach { cellViewModel in
            cellViewModel
                .element
                .$uiActions
                .receive(on: DispatchQueue.global(qos: .background))
                .sink { [weak self] state in
                    switch state {
                    case .subscriptionAction,
                            .shouldChangeName:
                        break
                    case .saveNewName(let name):
                        guard let self = self else { return }
                        self.foldersData[safe: cellViewModel.offset]?.folderName = name
                        StorageManager.setRewritingDataInLocalStorage(lists: self.foldersData)
                    }
                }
                .store(in: &observers)
        }
        observersManager.setRewriteValues(type: .cellsActionsArray, values: observers)
    }

    private func setUpdateCellsData() {
        cellsViewModel = foldersData.map({
            FolderTableViewCellViewModel(
                name: $0.folderName,
                wordsCount: $0.wordsModel.count)
        })
        setupCellsObservers()
        mainThreadActionState = .reloadData
    }

    func setUpdateData() {
        foldersData = StorageManager.getFoldersItemsFromLocalStorage()
        setUpdateCellsData()
    }

    func setSelectFolder(index: Int) {
        foldersData.forEach { $0.isSelected = false }
        foldersData[safe: index]?.isSelected = true
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
        setUpdateCellsData()
    }

    func setDeleteFolder(index: Int) {
        foldersData.remove(at: index)
        foldersData.first?.isSelected = true
        StorageManager.setRewritingDataInLocalStorage(lists: foldersData)
        setUpdateCellsData()
    }

    func setMoveWordTo(index: Int) {
        guard let movingWordId,
              let movingFromFolderId,
              let folderModel = foldersData.first(where: { $0.id == movingFromFolderId }),
              let wordModel = folderModel.wordsModel.first(where: { $0.id == movingWordId }),
              let selectedFolder = foldersData[safe: index] else { return }
        folderModel.wordsModel.removeAll { $0.id == movingWordId }
        selectedFolder.wordsModel.append(wordModel)
        StorageManager.setRewritingDataInLocalStorage(lists: foldersData)
        mainThreadActionState = .popToRoot
    }
}

extension FoldersTableViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case reloadData
        case popToRoot
    }
}

extension FoldersTableViewModel {
    enum Observers {
        case cellsActionsArray
    }
}
