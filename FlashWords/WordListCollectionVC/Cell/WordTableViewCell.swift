//
//  WordTableViewCell.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 15.12.2022.
//

import UIKit
import SnapKit

final class WordTableViewCell: UITableViewCell {
    static let withReuseIdentifier: String = .init(describing: WordTableViewCell.self)

    private lazy var foreignLabel: UILabel = {
        let foreignLabel = UILabel()
        foreignLabel.lineBreakMode = .byTruncatingTail
        foreignLabel.font = .avenirBold20
        foreignLabel.textColor = Asset.hexFCFCFC.color
        foreignLabel.textAlignment = .left
        return foreignLabel
    }()

    private lazy var nativeLabel: UILabel = {
        let nativeLabel = UILabel()
        nativeLabel.lineBreakMode = .byTruncatingTail
        nativeLabel.font = .avenirRegular16
        nativeLabel.textColor = Asset.hexFCFCFC.color
        nativeLabel.textAlignment = .left
        return nativeLabel
    }()

    func setupView(viewModel: WordTableViewCellViewModel) {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear

        foreignLabel.text = viewModel.foreignWord
        nativeLabel.text = viewModel.nativeWord

        contentView.addSubview(foreignLabel)
        foreignLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview()
        }

        contentView.addSubview(nativeLabel)
        nativeLabel.snp.makeConstraints { make in
            make.top.equalTo(foreignLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
        }


    }
}
