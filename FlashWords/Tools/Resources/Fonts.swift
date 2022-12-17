//
//  Fonts.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 14.12.2022.
//

import UIKit
import SwiftExtension

extension UIFont {
    static let systemRegular16: UIFont = .systemFont(ofSize: 16, weight: .regular)
    static let avenirBold18: UIFont = (UIFont.init(name: "Avenir Black", size: 18)).nonOptional(.systemRegular16)
    static let avenirBold36: UIFont = (UIFont.init(name: "Avenir Black", size: 36)).nonOptional(.systemRegular16)
    static let avenirRegular12: UIFont = (UIFont.init(name: "Avenir", size: 12)).nonOptional(.systemRegular16)
    static let avenirRegular16: UIFont = (UIFont.init(name: "Avenir", size: 16)).nonOptional(.systemRegular16)

}
