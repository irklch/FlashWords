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
    var viewState: ViewState = .closed
    var keyboardHeight: CGFloat = 0.0
    let initialHeight = NewWordInputView.ClosedOffsets.viewHeight
}

extension NewWordInputViewModel {
    enum MainThreadActionsState {
        case subscriptionAction
        case updateHeight(keyboardHeight: CGFloat, viewHeight: CGFloat)
        case hideNavigationBar
        case showNavigationBar
    }

    enum BackgroundThreadActionsState {
        case subscriptionAction
        case addedWord(WordsModelNonDB)
    }

    enum ViewState {
        case closed
        case shortOpened
        case fullOpened
    }
}
