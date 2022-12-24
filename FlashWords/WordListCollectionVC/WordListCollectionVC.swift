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
        titleLabel.textColor = Asset.hex6ECDCC.color
        return titleLabel
    }()

    private lazy var searchButton: UIButton = {
        let searchButton = UIButton()
        searchButton.setImage(Images.search, for: .normal)
        searchButton.addTarget(
            self,
            action: #selector(setSearchButtonAction),
            for: .touchUpInside)
        searchButton.tintColor = Asset.hexF2F2F2.color
        return searchButton
    }()

    private lazy var folderButton: UIButton = {
        let folderButton = UIButton()
        folderButton.setImage(Images.folder, for: .normal)
        folderButton.addTarget(
            self,
            action: #selector(setSearchButtonAction),
            for: .touchUpInside)
        folderButton.tintColor = Asset.hexF2F2F2.color
        return folderButton
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
        addListButton.tintColor = Asset.hex6ECDCC.color
        addListButton.addTarget(
            self,
            action: #selector(setAddNewList),
            for: .touchUpInside)
        return addListButton
    }()

    private lazy var inputTextView: UITextView = {
        let inputTextView = UITextView()
        inputTextView.backgroundColor = Asset.hex1D1C21.color
        inputTextView.font = .avenirRegular16
        inputTextView.layer.cornerRadius = 15.0
        inputTextView.textColor = Asset.hex7A7A7E.color
        inputTextView.showsVerticalScrollIndicator = false
        inputTextView.contentInset = .init(top: 7.0, left: 7.0, bottom: 0.0, right: 7.0)
        inputTextView.text = "New english word"
        inputTextView.delegate = self
        return inputTextView
    }()

    private lazy var grayView: UIView = {
        let grayView = UIView()
        grayView.backgroundColor = Asset.hex2E2C32.color
        grayView.layer.shadowColor = Asset.hex1D1C21.color.cgColor
        grayView.layer.shadowOpacity = 1
        grayView.layer.shadowOffset = .zero
        grayView.layer.shadowRadius = 1
#warning("пофиксить тень")
        return grayView
    }()

    private lazy var addWordButton: UIButton = {
        let addWordButton = UIButton()
        addWordButton.backgroundColor = Asset.hexF2F2F2.color
        addWordButton.setTitleColor(Asset.hex2E2C32.color, for: .normal)
        addWordButton.setTitle("Add", for: .normal)
        addWordButton.titleLabel?.font = .avenirMedium16
        addWordButton.layer.cornerRadius = 15.0
        addWordButton.isHidden = true
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
        view.backgroundColor = Asset.hex2E2C32.color
        setAddColorLayers()
        setAddBlurEffect()
        setupViews()
        setupHeaderConstraints()
        setupInputViewConstraints()
        setupCollectionViewConstraints()
        setKeyboardNotifications()
    }

    private func setupViews() {
        view.addSubview(grayView)
        grayView.addSubview(inputTextView)
        grayView.addSubview(addWordButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(addListButton)
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
            make.bottom.equalTo(grayView.snp.top)
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
               self?.grayView.snp.updateConstraints { make in
                   make.height.equalTo(keyboardSize.height.sum(Self.inputViewHeight).sum(50))
               }
               self?.inputTextView.snp.updateConstraints { make in
                   make.height.equalTo(58)
               }
               self?.view.layoutIfNeeded()
           }
           addWordButton.isHidden = false
       }

       @objc private func setKeyboardWillHide(_ notification: Notification) {
           UIView.animate(withDuration: 0.3) { [weak self] in
               self?.grayView.snp.updateConstraints { make in
                   make.height.equalTo(Self.inputViewHeight)
               }
               self?.inputTextView.snp.updateConstraints { make in
                   make.height.equalTo(35)
               }
               self?.view.layoutIfNeeded()
           }
           addWordButton.isHidden = true
       }

       @objc private func setAddNewList() {
           #warning("добавить событие добавления листа")
       }

       func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           view.endEditing(true)
       }



    @objc private func setSearchButtonAction() {
        #warning("добавить сёрч")
    }

    private func getColoredLayer(color: CGColor, cornerRadius: CGFloat) -> CALayer {
        let pinkLayer: CALayer = .init()
        pinkLayer.backgroundColor = color
        pinkLayer.cornerRadius = cornerRadius
        pinkLayer.shadowColor = color
        pinkLayer.shadowOpacity = 1
        pinkLayer.shadowOffset = .zero
        pinkLayer.shadowRadius = 80
        return pinkLayer
    }

    private func setAddBlurEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
    }

    private func setAddColorLayers() {
        #warning("переписать")
        let orangedLayer = getColoredLayer(color: Asset.hexF3C196.color.cgColor, cornerRadius: 100)
        let blueLayer = getColoredLayer(color: Asset.hex6ECDCC.color.cgColor, cornerRadius: 85)
        let redLayer = getColoredLayer(color: Asset.hexFFADAE.color.cgColor, cornerRadius: 125)

        orangedLayer.frame = .init(x: 100, y: 30, width: 200, height: 150)
        blueLayer.frame = .init(x: Self.viewWidth.subtraction(200), y: Self.viewHeight.subtraction(440), width: 150, height: 150)
        redLayer.frame = .init(x: 40, y: Self.viewHeight.subtraction(200), width: 250, height: 250)
        view.layer.addSublayer(orangedLayer)
        view.layer.addSublayer(blueLayer)
        view.layer.addSublayer(redLayer)
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

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == Asset.hex7A7A7E.color {
            textView.textColor = Asset.hexF2F2F2.color
            textView.text = .empty
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == .empty {
            textView.textColor = Asset.hex7A7A7E.color
            textView.text = "New english word"
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
