//
//  String+Sizes.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 17.12.2022.
//

import UIKit

extension String {
    func getHeight(
        forConstrainedWidth width: CGFloat,
        font: UIFont
    ) -> CGFloat {
        let constraintRect = CGSize(
            width: width,
            height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [
                .usesLineFragmentOrigin,
                .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return boundingBox.height
    }

    func getWidth(
        withConstrainedHeight height: CGFloat,
        maxWidth width: CGFloat = 0,
        font: UIFont
    ) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [ .font: font ]
        let attributedText = NSAttributedString(
            string: self,
            attributes: attributes)
        let constraintBox = CGSize(
            width: width,
            height: height)
        let rect = attributedText.boundingRect(
            with: constraintBox,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil)
            .integral
        return rect.size.width
    }
}
