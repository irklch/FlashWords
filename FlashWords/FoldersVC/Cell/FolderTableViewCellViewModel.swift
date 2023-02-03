//
//  FolderTableViewCellViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 22.01.2023.
//

import Foundation
import Combine

final class FolderTableViewCellViewModel {
    static let template: FolderTableViewCellViewModel = .init(name: .empty, wordsCount: 0)
    @Published var uiActions: Actions = .subscriptionAction
    var name: String
    let wordsCount: Int

    init(name: String, wordsCount: Int) {
        self.name = name
        self.wordsCount = wordsCount
    }
}

extension FolderTableViewCellViewModel {
    enum Actions {
        case subscriptionAction
        case shouldChangeName
        case saveNewName(String)
    }
}
