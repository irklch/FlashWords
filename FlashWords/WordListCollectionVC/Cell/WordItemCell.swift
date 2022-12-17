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

    private lazy var wordLabel: UILabel = {
        let wordLabel = UILabel()
        wordLabel.lineBreakMode = .byTruncatingTail
        wordLabel.font = .avenirBold18
        wordLabel.textColor = Asset.hexF2F2F2.color
        wordLabel.textAlignment = .left
        return wordLabel
    }()

    private lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = Images.arrow
        arrowImageView.tintColor = Asset.hexD0BBF9.color
        return arrowImageView
    }()

    func setupView(viewModel: WordItemCellViewModel) {
        isSelected = false
        backgroundColor = Asset.hex2E2C32.color
        layer.cornerRadius = 15.0

        wordLabel.text = viewModel.foreignWord
        addSubview(wordLabel)
        wordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
