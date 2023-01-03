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
    @Published var mainThreadActionsState: MainThreadActionsState = .subscriptionAction
    @Published var backgroundThreadActionsState: BackgroundThreadActionsState = .subscriptionAction

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
    enum MainThreadActionsState {
        case subscriptionAction
        case viewSelected
        case viewDeselected
    }

    enum BackgroundThreadActionsState {
        case subscriptionAction
        case addedWord(WordsModelNonDB)
    }
}
