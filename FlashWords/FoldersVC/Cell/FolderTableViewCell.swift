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

    private lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView()
        arrowImageView.image = Images.arrow
        arrowImageView.tintColor = Asset.hexFCFCFC.color
        return arrowImageView
    }()

    func setupView(viewModel: FolderTableViewCellViewModel) {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = Asset.hex5E5E69.color
        contentView.layer.cornerRadius = 15.0

        folderLabel.text = viewModel.name
        contentView.addSubview(folderLabel)
        folderLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }

        contentView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }

}
