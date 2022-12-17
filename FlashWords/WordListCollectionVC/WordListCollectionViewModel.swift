//
//  WordListCollectionViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 17.12.2022.
//

import Foundation

struct WordListCollectionViewModel {
    let cellsViewModel: [WordItemCellViewModel]

    init() {
        self.cellsViewModel = [
            .init(foreignWord: "name", netiveWord: "Имя"),
                .init(foreignWord: "Compatitive", netiveWord: "Подходящий"),
                .init(foreignWord: "Straight", netiveWord: "Обычный"),
                .init(foreignWord: "Close", netiveWord: "Близко")]
        #warning("добавить базу данных")
    }

}
