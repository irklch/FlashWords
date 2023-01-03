//
//  WordListCollectionVC.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 14.12.2022.
//

import UIKit
import SnapKit

final class WordListCollectionVC: UIViewController {
    private let viewModel: WordListCollectionViewModel = .init()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Titles.newListName
        titleLabel.font = .avenirBold36
        titleLabel.textColor = Asset.hexFCFCFC.color
        return titleLabel
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionFlow = UICollectionViewFlowLayout()
        collectionFlow.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionFlow)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(
            top: 0.0,
            left: 16.0,
            bottom: 20.0,
            right: 16.0)
        collectionView.register(
            WordItemCell.self,
            forCellWithReuseIdentifier: WordItemCell.withReuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private lazy var addListButton: UIButton = {
        let addListButton = UIButton()
        addListButton.setImage(Images.plus, for: .normal)
        addListButton.tintColor = Asset.hexFCFCFC.color
        addListButton.addTarget(
            self,
            action: #selector(setAddNewList),
            for: .touchUpInside)
        return addListButton
    }()

    private lazy var newWordInputView: NewWordInputView = .init(viewModel: viewModel.inputTextViewModel)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.hex333337.color
        setupViews()
        setupHeaderConstraints()
        setupCollectionAndInputViewConstraints()
        setKeyboardNotifications()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(addListButton)
        view.addSubview(newWordInputView)
    }

    private func setupHeaderConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        addListButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.width.equalTo(30)
        }
    }

    private func setupCollectionAndInputViewConstraints() {
        let inputViewHeight = viewModel.inputTextViewModel.getViewHeight(isOpened: false)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-inputViewHeight)
        }

        newWordInputView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(inputViewHeight)
        }
    }

    private func setKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    @objc private func setKeyboardWillShow(_ notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            let inputViewOpenedHeight = self.viewModel.inputTextViewModel.getViewHeight(isOpened: true)
            let inputViewHeightWithKeyboard = keyboardSize.height.sum(inputViewOpenedHeight)
            self.newWordInputView.snp.updateConstraints { make in
                make.height.equalTo(inputViewHeightWithKeyboard)
            }

            self.collectionView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-inputViewHeightWithKeyboard)
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc private func setKeyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            let inputViewClosedHeight = self.viewModel.inputTextViewModel.getViewHeight(isOpened: false)
            self.newWordInputView.snp.updateConstraints { make in
                make.height.equalTo(inputViewClosedHeight)
            }
            self.collectionView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-inputViewClosedHeight)
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc private func setAddNewList() {
#warning("добавить событие добавления листа")
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

}

extension WordListCollectionVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.selectedListData.wordsModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WordItemCell.withReuseIdentifier,
            for: indexPath) as? WordItemCell,
              let wordsData = viewModel.selectedListData.wordsModel[safe: indexPath.row] else {
            return .init(frame: .zero)
        }
        cell.setupView(viewModel: .init(data: wordsData))
        return cell
    }
}

extension WordListCollectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension WordListCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(
            width: UIScreen.main.bounds.width.subtraction(36),
            height: 50.0)
    }
}


