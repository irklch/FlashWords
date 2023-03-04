//
//  NewWordInputView+Offsets.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 05.03.2023.
//

import Foundation

extension NewWordInputView {
    enum ClosedOffsets {
        static let textViewTopOffset: CGFloat = 8.0
        static let textViewLeadingOffset: CGFloat = 16.0
        static let textViewTrailingOffset: CGFloat = 16.0
        static let textViewBottomOffset: CGFloat = 12.0
        static let textViewHeight: CGFloat = 20.0

        static let backgroundViewTopOffset: CGFloat = 8.0
        static let backgroundViewLeadingOffset: CGFloat = 20.0
        static let backgroundViewTrailingOffset: CGFloat = 20.0
            .sum(fullInputButtonTrailingOffset)
            .sum(fullInputButtonSize)
        static let backgroundViewHeight: CGFloat = backgroundViewTopOffset
            .sum(textViewHeight)
            .sum(textViewBottomOffset)

        static let fullInputButtonTrailingOffset: CGFloat = 20.0
        static let fullInputButtonSize: CGFloat = 20.0

        static let viewBottomOffset: CGFloat = 20.0
        static let viewHeight: CGFloat = backgroundViewTopOffset
            .sum(backgroundViewHeight)
            .sum(viewBottomOffset)
    }

    enum ShortOpenedOffsets {
        static let separatorLineHeight: CGFloat = 1.0
        static let textViewTopOffset: CGFloat = 8.0
        static let textViewLeadingOffset: CGFloat = 16.0
        static let textViewTrailingOffset: CGFloat = 32.0
            .sum(fullInputButtonSize)
        static let textViewBottomOffset: CGFloat = 12.0
        static let textViewHeight: CGFloat = 50.0

        static let backgroundViewTopOffset: CGFloat = 8.0
        static let backgroundViewLeadingOffset: CGFloat = 20.0
        static let backgroundViewTrailingOffset: CGFloat = 20.0
        static let backgroundViewHeight: CGFloat = textViewTopOffset
            .sum(textViewHeight)
            .sum(textViewBottomOffset)
            .sum(separatorLineHeight)
            .sum(textViewBottomOffset)
            .sum(textViewHeight)
            .sum(textViewBottomOffset)

        static let fullInputButtonTrailingOffset: CGFloat = 36.0
        static let fullInputButtonSize: CGFloat = 20.0

        static let addWordButtonTopOffset: CGFloat = 12.0
        static let addWordButtonBottomOffset: CGFloat = 12.0
        static let addWordButtonHeight: CGFloat = 30.0
        static let addWordButtonOriginalWidth: CGFloat = 65.0
        static let addWordButtonErrorWidth: CGFloat = 230.0

        static let viewHeight: CGFloat = backgroundViewTopOffset
            .sum(backgroundViewHeight)
            .sum(addWordButtonTopOffset)
            .sum(addWordButtonHeight)
            .sum(addWordButtonBottomOffset)
    }

    enum FullOpenedOffsets {
        static let separatorLineHeight: CGFloat = 1.0

        static let textViewLeadingOffset: CGFloat = 16.0
        static let textViewTrailingOffset: CGFloat = 16.0
        static let textViewBottomOffset: CGFloat = 12.0
        static let textViewHeight: CGFloat = 120.0

        static let backgroundViewTopOffset: CGFloat = 104.0
        static let backgroundViewHeight: CGFloat = textViewHeight
            .sum(textViewBottomOffset)
            .sum(separatorLineHeight)
            .sum(textViewBottomOffset)
            .sum(textViewHeight)
            .sum(textViewBottomOffset)


    }
}
