//
//  FolderTableViewCell.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 22.01.2023.
//

import UIKit
import SnapKit
import Combine

final class FolderTableViewCell: UITableViewCell {
    static let withReuseIdentifier: String = .init(describing: FolderTableViewCell.self)

    private var viewModel: FolderTableViewCellViewModel = .template

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
        wordsCountLabel.font = Self.wordsCountLabelFont
        wordsCountLabel.textColor = Asset.hexFCFCFC.color.withAlphaComponent(0.7)
        wordsCountLabel.textAlignment = .right
        return wordsCountLabel
    }()

    private lazy var folderNameTextField: UITextField = {
        let folderNameTextField = UITextField()
        folderNameTextField.backgroundColor = .clear
        folderNameTextField.font = .avenirBold18
        folderNameTextField.textColor = Asset.hexFCFCFC.color
        folderNameTextField.delegate = self
        folderNameTextField.isUserInteractionEnabled = false
        folderNameTextField.returnKeyType = .done
        folderNameTextField.enablesReturnKeyAutomatically = true
        folderNameTextField.autocapitalizationType = .sentences
        return folderNameTextField
    }()

    var uiActionObserver: AnyCancellable?

    func setupView(viewModel: FolderTableViewCellViewModel) {
        self.viewModel = viewModel
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = Asset.hex5E5E69.color

        folderNameTextField.text = viewModel.name
        wordsCountLabel.text = viewModel.wordsCount.description
        setupViews()
        setupObserver()
    }

    private func setupViews() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(folderImageView)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(wordsCountLabel)
        contentView.addSubview(folderNameTextField)

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

        let wordsCountLabelWidth: CGFloat = viewModel.wordsCount.description.getWidth(
            withConstrainedHeight: 22.0,
            font: Self.wordsCountLabelFont).ceil()
        wordsCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(arrowImageView.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
            make.width.equalTo(wordsCountLabelWidth)
        }

        folderNameTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalTo(wordsCountLabel.snp.leading).offset(-16)
            make.leading.equalTo(folderImageView.snp.trailing).offset(10)
        }
    }

    private func setupObserver() {
       uiActionObserver = viewModel
            .$uiActions
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .subscriptionAction,
                        .saveNewName:
                    break
                case .shouldChangeName:
                    self?.folderNameTextField.isUserInteractionEnabled = true
                    self?.folderNameTextField.becomeFirstResponder()
                }
            }
    }

}

extension FolderTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text,
              text.textWithoutSpacePrefix() != .empty else {
            textField.text = viewModel.name
            endEditing(true)
            textField.isUserInteractionEnabled = false
            return 
        }
        viewModel.name = text
        viewModel.uiActions = .saveNewName(text)
        endEditing(true)
        textField.isUserInteractionEnabled = false
    }
}

extension FolderTableViewCell {
    private static let wordsCountLabelFont: UIFont = .avenirMedium16
}
