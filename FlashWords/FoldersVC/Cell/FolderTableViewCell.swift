//
//  FolderTableViewCell.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 22.01.2023.
//

import UIKit
import SnapKit

final class FolderTableViewCell: UITableViewCell {
    static let withReuseIdentifier: String = .init(describing: FolderTableViewCell.self)

    private lazy var folderLabel: UILabel = {
        let folderLabel = UILabel()
        folderLabel.lineBreakMode = .byTruncatingTail
        folderLabel.font = .avenirBold18
        folderLabel.textColor = Asset.hexFCFCFC.color
        folderLabel.textAlignment = .left
        return folderLabel
    }()

    private lazy var folderImageView: UIImageView = {
        let folderImageView = UIImageView()
        folderImageView.image = Images.folder
        folderImageView.tintColor = Asset.hexFCFCFC.color
        return folderImageView
    }()

    private lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = Images.arrow
        arrowImageView.tintColor = Asset.hexFCFCFC.color.withAlphaComponent(0.7)
        return arrowImageView
    }()

    private lazy var wordsCountLabel: UILabel = {
        let wordsCountLabel = UILabel()
        wordsCountLabel.font = .avenirMedium16
        wordsCountLabel.textColor = Asset.hexFCFCFC.color.withAlphaComponent(0.7)
        wordsCountLabel.textAlignment = .right
        wordsCountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return wordsCountLabel
    }()

    func setupView(viewModel: FolderTableViewCellViewModel) {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = Asset.hex5E5E69.color
        contentView.layer.cornerRadius = 15.0

        folderLabel.text = viewModel.name
        wordsCountLabel.text = viewModel.wordsCount.description

        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(folderImageView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(wordsCountLabel)
        contentView.addSubview(folderLabel)

        folderImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.height.equalTo(21)
            make.width.equalTo(27)
        }

        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(13)
        }

        wordsCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }

        folderLabel.snp.makeConstraints { make in
            make.centerY.equalTo(folderImageView).offset(1)
            make.trailing.equalTo(wordsCountLabel.snp.leading).offset(-16)
            make.leading.equalTo(folderImageView.snp.trailing).offset(10)
        }

    }

}
