//
//  WordItemCell.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 15.12.2022.
//

import UIKit
import SnapKit

final class WordItemCell: UICollectionViewCell {
    static let withReuseIdentifier: String = .init(describing: WordItemCell.self)

    func setupView(viewModel: WordItemCellViewModel) {
        isSelected = false
        backgroundColor = Asset.hex2E2C32.color
        layer.cornerRadius = 10.0
        subviews.forEach { $0.removeFromSuperview() }
        let firstLanguageLabel = Self.getLanguageLabel(text: viewModel.firstLanguage)
        let firstWordLabel = Self.getWordLabel(text: viewModel.firstWord)
        let secondLanguageLabel = Self.getLanguageLabel(text: viewModel.secodLanguage)
        let secondWordLabel = Self.getWordLabel(text: viewModel.secondWord)

        addSubview(firstLanguageLabel)
        addSubview(firstWordLabel)
        addSubview(secondLanguageLabel)
        addSubview(secondWordLabel)

        
        firstLanguageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private static func getLanguageLabel(text: String) -> UILabel {
        let languageLabel = UILabel()
        languageLabel.text = text
        languageLabel.lineBreakMode = .byTruncatingTail
        languageLabel.font = .avenirRegular12
        languageLabel.textColor = Asset.hexF2F2F2.color
        return languageLabel
    }

    private static func getWordLabel(text: String) -> UILabel {
        let languageLabel = UILabel()
        languageLabel.text = text
        languageLabel.lineBreakMode = .byTruncatingTail
        languageLabel.font = .avenirRegular16
        languageLabel.textColor = Asset.hexF2F2F2.color
        return languageLabel
    }

}
