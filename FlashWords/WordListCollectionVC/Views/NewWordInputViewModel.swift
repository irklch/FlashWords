//
//  NewWordInputViewModel.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 03.01.2023.
//

import Foundation
import Combine
import SwiftExtension

final class NewWordInputViewModel {
    @Published var actionsState: ActionsState = .subscriptionAction

    func getViewHeight(isOpened: Bool) -> CGFloat {
        return Ternary.get(
            if: .value(isOpened),
            true: .func({
                let height = NewWordInputViewOffsets.inputBackgroundViewTopOffset
                    .sum(NewWordInputViewOffsets.inputBackgroundViewOpenedHeight)
                    .sum(NewWordInputViewOffsets.addWordButtonTopOffset)
                    .sum(NewWordInputViewOffsets.addWordButtonHeight)
                    .sum(NewWordInputViewOffsets.addWordButtonBottomOffset)
                return height
            }),
            false: .func({
                let height = NewWordInputViewOffsets.inputBackgroundViewTopOffset
                    .sum(NewWordInputViewOffsets.inputBackgroundViewClosedHeight)
                    .sum(NewWordInputViewOffsets.viewClosedBottomOffset)
                return height
            }))
    }
}

extension NewWordInputViewModel {
    enum ActionsState {
        case subscriptionAction
        case viewSelected
        case viewDeselected
        case addedWord(WordsModelNonDB)
    }
}
