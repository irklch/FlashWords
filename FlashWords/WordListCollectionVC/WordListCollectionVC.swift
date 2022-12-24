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

#warning("вынести в отдельную вью")
    private lazy var inputTextView: UITextView = {
        let inputTextView = UITextView()
        inputTextView.backgroundColor = Asset.hex333337.color
        inputTextView.font = .avenirRegular16
        inputTextView.layer.cornerRadius = 15.0
        inputTextView.textColor = Asset.hex7A7A7E.color
        inputTextView.showsVerticalScrollIndicator = false
        inputTextView.textContainerInset = .init(
            top: 8.0,
            left: 8.0,
            bottom: 0.0,
            right: 8.0)
        inputTextView.text = "New english word"
        inputTextView.delegate = self
        inputTextView.isScrollEnabled = false
        return inputTextView
    }()

    private lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = Asset.hex424247.color
        grayView.layer.shadowColor = Asset.hex000000.color.cgColor
        grayView.layer.shadowOpacity = 1
        grayView.layer.shadowOffset = .zero
        grayView.layer.shadowRadius = 1
#warning("пофиксить тень")
        return grayView
    }()

    private lazy var addWordButton: UIButton = {
        let addWordButton = UIButton()
        addWordButton.backgroundColor = Asset.hexFCFCFC.color
        addWordButton.setTitleColor(Asset.hex424247.color, for: .normal)
        addWordButton.setTitle("Add", for: .normal)
        addWordButton.titleLabel?.font = .avenirMedium16
        addWordButton.layer.cornerRadius = 15.0
        addWordButton.alpha = 0
        addWordButton.addTarget(
            self,
            action: #selector(setAddWordInVocabulary),
            for: .touchUpInside)
        return addWordButton
    }()

    private static let viewHeight = UIScreen.main.bounds.height
    private static let viewWidth = UIScreen.main.bounds.width
    private static let inputViewHeight: CGFloat = 64.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.hex333337.color
        setupViews()
        setupHeaderConstraints()
        setupCollectionViewConstraints()
        setupInputViewConstraints()
        setKeyboardNotifications()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(addListButton)
        view.addSubview(grayView)
        grayView.addSubview(inputTextView)
        grayView.addSubview(addWordButton)
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

    private func setupCollectionViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Self.inputViewHeight)
        }
    }

    private func setupInputViewConstraints() {
        grayView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(Self.inputViewHeight)
        }

        inputTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(35)
        }

        addWordButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextView.snp.bottom).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
            make.width.equalTo(65)
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
            let grayViewHeight = keyboardSize.height.sum(Self.inputViewHeight).sum(50)
            self.grayView.snp.updateConstraints { make in
                make.height.equalTo(grayViewHeight)
            }
            self.inputTextView.snp.updateConstraints { make in
                make.height.equalTo(58)
            }
            self.collectionView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-grayViewHeight)
            }
            self.addWordButton.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    @objc private func setKeyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.grayView.snp.updateConstraints { make in
                make.height.equalTo(Self.inputViewHeight)
            }
            self.inputTextView.snp.updateConstraints { make in
                make.height.equalTo(35)
            }
            self.collectionView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-Self.inputViewHeight)
            }
            self.addWordButton.alpha = 0
            self.view.layoutIfNeeded()
        }
    }

    @objc private func setAddNewList() {
#warning("добавить событие добавления листа")
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }


    @objc private func setAddWordInVocabulary() {
#warning("добавить событие добавления")
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
        return viewModel.cellsViewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WordItemCell.withReuseIdentifier,
            for: indexPath) as? WordItemCell,
              let viewModel = viewModel.cellsViewModel[safe: indexPath.row] else {
            return .init(frame: .zero)
        }
        cell.setupView(viewModel: viewModel)
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
            width: Self.viewWidth.subtraction(36),
            height: 50.0)
    }
}


extension WordListCollectionVC: UITextViewDelegate {
    #warning("добавить расчёт высоты")
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == Asset.hex7A7A7E.color {
            textView.textColor = Asset.hexF2F2F2.color
            textView.text = .empty
            textView.isScrollEnabled = true
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == .empty {
            textView.textColor = Asset.hex7A7A7E.color
            textView.text = "New english word"
            textView.isScrollEnabled = false
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        let text = textView.text.nonOptional()

        guard !text.contains(Symbols.returnCommand) else {
            textView.text = text.replacingOccurrences(
                of: Symbols.returnCommand,
                with: String.empty)
            view.endEditing(true)
            return
        }
    }
}
