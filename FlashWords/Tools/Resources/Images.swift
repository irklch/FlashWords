//
//  Images.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 15.12.2022.
//

import UIKit

enum Images {
    private static let largeConfig: UIImage.SymbolConfiguration = .init(
        pointSize: 25,
        weight: .regular,
        scale: .default)
    private static let mediumConfig: UIImage.SymbolConfiguration = .init(
        pointSize: 20,
        weight: .regular,
        scale: .medium)
    static let folder: UIImage? = .init(
        systemName: "folder",
        withConfiguration: largeConfig)?
        .withRenderingMode(.alwaysTemplate)
    static let search: UIImage? = .init(
        systemName: "magnifyingglass",
        withConfiguration: largeConfig)?
        .withRenderingMode(.alwaysTemplate)
    static let arrow: UIImage? = .init(
        systemName: "arrow.right.circle",
        withConfiguration: mediumConfig)?
        .withRenderingMode(.alwaysTemplate)
    static let plus: UIImage? = .init(
        systemName: "plus.circle.fill",
        withConfiguration: largeConfig)?
        .withRenderingMode(.alwaysTemplate)
    static let checkmark: UIImage? = .init(
        systemName: "checkmark.circle.fill",
        withConfiguration: largeConfig)?
        .withRenderingMode(.alwaysTemplate)
}
