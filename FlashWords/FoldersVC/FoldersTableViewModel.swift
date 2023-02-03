//
//  FoldersTableViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 05.01.2023.
//

import Foundation
import Combine

final class FoldersTableViewModel {
    @Published var mainThreadActionState: MainThreadActionsState = .subscriptionAction
    var cellsViewModel: [FolderTableViewCellViewModel]
    var isEditingMode: Bool = false

    private var foldersData: [FoldersModelNonDB]
    private let observersManager = AnyCancellableManager<Observers>()

    init() {
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
        cellsViewModel = foldersData.map({ FolderTableViewCellViewModel(
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
}

extension FoldersTableViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case reloadData
    }
}

extension FoldersTableViewModel {
    enum Observers {
        case cellsActionsArray
    }
}
