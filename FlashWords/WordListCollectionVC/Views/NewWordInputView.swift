//
//  NewWordInputView.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 03.01.2023.
//

import UIKit
import SnapKit
import Combine
import SwiftExtension

final class NewWordInputView: UIView {
    private let viewModel: NewWordInputViewModel

    private lazy var inputBackgroundView: UIView = {
        let inputBackgroundView = UIView()
        inputBackgroundView.backgroundColor = Asset.hex333337.color
        inputBackgroundView.layer.cornerRadius = 15.0
        return inputBackgroundView
    }()

    private lazy var foreignTextView: UITextView = {
        let foreignTextView = UITextView()
        foreignTextView.backgroundColor = .clear
        foreignTextView.font = .avenirRegular16
        foreignTextView.textColor = Asset.hex7A7A7E.color
        foreignTextView.showsVerticalScrollIndicator = false
        foreignTextView.textContainerInset = .zero
        foreignTextView.text = Titles.newWord
        foreignTextView.delegate = self
        foreignTextView.isScrollEnabled = false
        foreignTextView.autocapitalizationType = .sentences
        return foreignTextView
    }()

    private lazy var nativeTextView: UITextView = {
        let nativeTextView = UITextView()
        nativeTextView.backgroundColor = .clear
        nativeTextView.font = .avenirRegular16
        nativeTextView.textColor = Asset.hex7A7A7E.color
        nativeTextView.showsVerticalScrollIndicator = false
        nativeTextView.textContainerInset = .zero
        nativeTextView.text = Titles.translation
        nativeTextView.delegate = self
        nativeTextView.isScrollEnabled = false
        nativeTextView.alpha = 0
        nativeTextView.autocapitalizationType = .sentences
        return nativeTextView
    }()

    private lazy var addWordButton: UIButton = {
        let addWordButton = UIButton()
        addWordButton.backgroundColor = Asset.hexFCFCFC.color
        addWordButton.setTitleColor(Asset.hex424247.color, for: .normal)
        addWordButton.setTitle(Titles.add, for: .normal)
        addWordButton.titleLabel?.font = .avenirMedium16
        addWordButton.layer.cornerRadius = 15.0
        addWordButton.alpha = 0
        addWordButton.addTarget(
            self,
            action: #selector(setAddWordInVocabulary),
            for: .touchUpInside)
        return addWordButton
    }()

    private lazy var separatorLineLayer: CALayer = {
        let separatorLineLayer = CALayer()
        separatorLineLayer.backgroundColor = Asset.hex424247.color.cgColor
        return separatorLineLayer
    }()

    private lazy var fullInputButton: UIButton = {
        let fullInputButton = UIButton()
        fullInputButton.setImage(Images.fullInput, for: .normal)
        fullInputButton.addTarget(
            self,
            action: #selector(setOpenFullInputScreen),
            for: .touchUpInside)
        fullInputButton.tintColor = Asset.hex7A7A7E.color
        return fullInputButton
    }()

    private var actionsObserver: AnyCancellable?

    init(viewModel: NewWordInputViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupViewsConstraints()
        setKeyboardNotifications()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = Asset.hex424247.color
        layer.shadowColor = Asset.hex000000.color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        addSubview(inputBackgroundView)
        inputBackgroundView.addSubview(foreignTextView)
        inputBackgroundView.addSubview(nativeTextView)
        addSubview(addWordButton)
        addSubview(fullInputButton)
    }

    private func setupViewsConstraints() {
        inputBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .inset(ClosedOffsets.backgroundViewTopOffset)
            make.leading.equalToSuperview()
                .inset(ClosedOffsets.backgroundViewLeadingOffset)
            make.trailing.equalToSuperview()
                .offset(-ClosedOffsets.backgroundViewTrailingOffset)
            make.height.equalTo(ClosedOffsets.backgroundViewHeight)
        }

        foreignTextView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset(ClosedOffsets.textViewTopOffset)
            make.leading.equalToSuperview()
                .inset(ClosedOffsets.textViewLeadingOffset)
            make.trailing.equalToSuperview()
                .inset(-ClosedOffsets.textViewTrailingOffset)
            make.height.equalTo(ClosedOffsets.textViewHeight)
        }

        nativeTextView.snp.makeConstraints { make in
            make.top.equalTo(foreignTextView.snp.bottom)
            make.leading.equalToSuperview()
                .inset(ClosedOffsets.textViewLeadingOffset)
            make.trailing.equalToSuperview()
                .inset(-ClosedOffsets.textViewTrailingOffset)
            make.height.equalTo(ClosedOffsets.textViewHeight)
        }

        addWordButton.snp.makeConstraints { make in
            make.top.equalTo(inputBackgroundView.snp.bottom)
                .offset(ShortOpenedOffsets.addWordButtonTopOffset)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(ShortOpenedOffsets.addWordButtonHeight)
            make.width.equalTo(65)
        }

        fullInputButton.snp.makeConstraints { make in
            make.centerY.equalTo(inputBackgroundView)
            make.trailing.equalToSuperview()
                .offset(-ClosedOffsets.fullInputButtonTrailingOffset)
            make.height.width.equalTo(ClosedOffsets.fullInputButtonSize)
        }
    }

    @objc private func setAddWordInVocabulary() {
        let foreignText = foreignTextView.text.textWithoutSpacePrefix()
        let nativeText = nativeTextView.text.textWithoutSpacePrefix()

        if (foreignText == .empty)
            .or(foreignText == .space)
            .or(nativeText == .empty)
            .or(nativeText == .space)
            .or(foreignTextView.textColor == Asset.hex7A7A7E.color)
            .or(nativeTextView.textColor == Asset.hex7A7A7E.color)
        {
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.addWordButton.setTitle(Titles.youNeedToWriteWords, for: .normal)
                self?.addWordButton.setTitleColor(Asset.hexCD626F.color, for: .normal)
                self?.addWordButton.snp.updateConstraints({ make in
                    make.width.equalTo(ShortOpenedOffsets.addWordButtonErrorWidth)
                })
                self?.layoutIfNeeded()
            } completion: { [weak self] _ in
                UIView.animate(withDuration: 0.1, delay: 2) { [weak self] in
                    self?.addWordButton.snp.updateConstraints({ make in
                        make.width.equalTo(ShortOpenedOffsets.addWordButtonOriginalWidth)
                    })
                    self?.layoutIfNeeded()
                } completion: { [weak self] _ in
                    self?.addWordButton.setTitleColor(Asset.hex424247.color, for: .normal)
                    self?.addWordButton.setTitle(Titles.add, for: .normal)
                }
            }

            return
        }

        let wordModel: WordsModelNonDB = .init(
            id: foreignText.hashValue,
            foreignWord: foreignText,
            nativeWord: nativeText)
        viewModel.backgroundThreadActionsState = .addedWord(wordModel)
        setTextViewStartState(foreignTextView)
        setTextViewStartState(nativeTextView)
        endEditing(true)
    }

    private func setTextViewStartState(_ textView: UITextView) {
        textView.textColor = Asset.hex7A7A7E.color
        textView.text = Ternary.get(
            if: .value(textView == foreignTextView),
            true: .value(Titles.newWord),
            false: .value(Titles.translation))
        textView.isScrollEnabled = false
    }

    @objc func setOpenFullInputScreen() {
        if viewModel.viewState == .closed {
            foreignTextView.becomeFirstResponder()
            viewModel.viewState = .fullOpened
        } else {
            viewModel.viewState = .fullOpened
            let height = UIScreen.mainHeight.subtraction(viewModel.keyboardHeight)
            viewModel.mainThreadActionsState = .hideNavigationBar
            viewModel.mainThreadActionsState = .updateHeight(
                keyboardHeight: viewModel.keyboardHeight,
                viewHeight: height)
            setFullOpenedViewState()
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
        viewModel.keyboardHeight = keyboardSize.height
        switch viewModel.viewState {
        case .closed:
            viewModel.viewState = .shortOpened
            viewModel.mainThreadActionsState = .updateHeight(
                keyboardHeight: keyboardSize.height,
                viewHeight: ShortOpenedOffsets.viewHeight)
            setShortOpenedViewState()
        case .shortOpened:
            break
        case .fullOpened:
            viewModel.viewState = .fullOpened
            let height = UIScreen.mainHeight.subtraction(keyboardSize.height)
            viewModel.mainThreadActionsState = .hideNavigationBar
            viewModel.mainThreadActionsState = .updateHeight(
                keyboardHeight: keyboardSize.height,
                viewHeight: height)
            setFullOpenedViewState()
        }
    }

    private func setFullOpenedViewState() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = Asset.hex333337.color

            self.inputBackgroundView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                    .offset(FullOpenedOffsets.backgroundViewTopOffset)
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(FullOpenedOffsets.backgroundViewHeight)
            }

            self.foreignTextView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                    .inset(FullOpenedOffsets.textViewLeadingOffset)
                make.trailing.equalToSuperview()
                    .inset(-FullOpenedOffsets.textViewTrailingOffset)
                make.height.equalTo(FullOpenedOffsets.textViewHeight)
            }

            let nativeTextViewTopOffset = FullOpenedOffsets.textViewBottomOffset
                .sum(FullOpenedOffsets.separatorLineHeight)
                .sum(FullOpenedOffsets.textViewBottomOffset)

            self.nativeTextView.snp.remakeConstraints { make in
                make.top.equalTo(self.foreignTextView.snp.bottom)
                    .offset(nativeTextViewTopOffset)
                make.leading.equalToSuperview()
                    .inset(FullOpenedOffsets.textViewLeadingOffset)
                make.trailing.equalToSuperview()
                    .inset(-FullOpenedOffsets.textViewTrailingOffset)
                make.height.equalTo(FullOpenedOffsets.textViewHeight)
            }

            self.addWordButton.alpha = 0
            self.fullInputButton.alpha = 0
            self.nativeTextView.alpha = 1
            self.setupSeparatorLineLayerForFullOpenedView()
            self.layoutIfNeeded()
        }
    }

    private func setupSeparatorLineLayerForFullOpenedView() {
        separatorLineLayer.removeFromSuperlayer()
        separatorLineLayer.isHidden = false
        let layerWidth: CGFloat = UIScreen.mainWidth
            .subtraction(FullOpenedOffsets.textViewLeadingOffset)
            .subtraction(FullOpenedOffsets.textViewTrailingOffset)
        let layerY: CGFloat = FullOpenedOffsets.textViewHeight
            .sum(FullOpenedOffsets.textViewBottomOffset)
        inputBackgroundView.layer.addSublayer(separatorLineLayer)
        separatorLineLayer.frame = .init(
            x: FullOpenedOffsets.textViewLeadingOffset,
            y: layerY,
            width: layerWidth,
            height: FullOpenedOffsets.separatorLineHeight)
    }

    private func setShortOpenedViewState() {
        backgroundColor = Asset.hex424247.color
//        UIView.animate(withDuration: 0.1) { [weak self] in
//            guard let self = self else { return }
            self.backgroundColor = Asset.hex424247.color

            self.inputBackgroundView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                    .inset(ShortOpenedOffsets.backgroundViewTopOffset)
                make.leading.equalToSuperview()
                    .inset(ShortOpenedOffsets.backgroundViewLeadingOffset)
                make.trailing.equalToSuperview()
                    .offset(-ShortOpenedOffsets.backgroundViewTrailingOffset)
                make.height.equalTo(ShortOpenedOffsets.backgroundViewHeight)
            }

            self.foreignTextView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                    .offset(ShortOpenedOffsets.textViewTopOffset)
                make.leading.equalToSuperview()
                    .inset(ShortOpenedOffsets.textViewLeadingOffset)
                make.trailing.equalToSuperview()
                    .inset(-ShortOpenedOffsets.textViewTrailingOffset)
                make.height.equalTo(ShortOpenedOffsets.textViewHeight)
            }

            let nativeTextViewTopOffset = ShortOpenedOffsets.textViewBottomOffset
                .sum(ShortOpenedOffsets.separatorLineHeight)
                .sum(ShortOpenedOffsets.textViewBottomOffset)

            self.nativeTextView.snp.remakeConstraints { make in
                make.top.equalTo(self.foreignTextView.snp.bottom)
                    .offset(nativeTextViewTopOffset)
                make.leading.equalToSuperview()
                    .inset(ShortOpenedOffsets.textViewLeadingOffset)
                make.trailing.equalToSuperview()
                    .inset(-ShortOpenedOffsets.textViewTrailingOffset)
                make.height.equalTo(ShortOpenedOffsets.textViewHeight)
            }

            self.fullInputButton.snp.remakeConstraints { make in
                make.centerY.equalTo(self.inputBackgroundView)
                make.trailing.equalToSuperview()
                    .offset(-ShortOpenedOffsets.fullInputButtonTrailingOffset)
                make.height.width.equalTo(ClosedOffsets.fullInputButtonSize)
            }

            self.fullInputButton.alpha = 1
            self.nativeTextView.alpha = 1
            self.addWordButton.alpha = 1
            self.setupSeparatorLineLayerForShortOpenedView()
//            self.layoutIfNeeded()
//        }
    }

    private func setupSeparatorLineLayerForShortOpenedView() {
        separatorLineLayer.isHidden = false
        separatorLineLayer.removeFromSuperlayer()
        let layerWidth: CGFloat = UIScreen.mainWidth
            .subtraction(ShortOpenedOffsets.backgroundViewLeadingOffset)
            .subtraction(ShortOpenedOffsets.backgroundViewTrailingOffset)
            .subtraction(ShortOpenedOffsets.textViewLeadingOffset)
            .subtraction(ShortOpenedOffsets.textViewTrailingOffset)
        let layerY: CGFloat = ShortOpenedOffsets.textViewTopOffset
            .sum(ShortOpenedOffsets.textViewHeight)
            .sum(ShortOpenedOffsets.textViewBottomOffset)
        inputBackgroundView.layer.addSublayer(separatorLineLayer)
        separatorLineLayer.frame = .init(
            x: ShortOpenedOffsets.textViewLeadingOffset,
            y: layerY,
            width: layerWidth,
            height: ShortOpenedOffsets.separatorLineHeight)
    }


    @objc private func setKeyboardWillHide(_ notification: Notification) {
        backgroundColor = Asset.hex424247.color
        viewModel.viewState = .closed
        viewModel.mainThreadActionsState = .showNavigationBar
        viewModel.mainThreadActionsState = .updateHeight(
            keyboardHeight: 0.0,
            viewHeight: ClosedOffsets.viewHeight)
        setClosedViewState()
    }

    private func setClosedViewState() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.inputBackgroundView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                    .inset(ClosedOffsets.backgroundViewTopOffset)
                make.leading.equalToSuperview()
                    .inset(ClosedOffsets.backgroundViewLeadingOffset)
                make.trailing.equalToSuperview()
                    .offset(-ClosedOffsets.backgroundViewTrailingOffset)
                make.height.equalTo(ClosedOffsets.backgroundViewHeight)
            }

            self.foreignTextView.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                    .offset(ClosedOffsets.textViewTopOffset)
                make.leading.equalToSuperview()
                    .inset(ClosedOffsets.textViewLeadingOffset)
                make.trailing.equalToSuperview()
                    .inset(-ClosedOffsets.textViewTrailingOffset)
                make.height.equalTo(ClosedOffsets.textViewHeight)
            }

            self.fullInputButton.snp.remakeConstraints { make in
                make.centerY.equalTo(self.inputBackgroundView)
                make.trailing.equalToSuperview()
                    .offset(-ClosedOffsets.fullInputButtonTrailingOffset)
                make.height.width.equalTo(ClosedOffsets.fullInputButtonSize)
            }

            self.fullInputButton.alpha = 1
            self.separatorLineLayer.isHidden = true
            self.nativeTextView.alpha = 0
            self.addWordButton.alpha = 0
            self.layoutIfNeeded()
        }
    }
}

extension NewWordInputView: UITextViewDelegate {
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
            setTextViewStartState(textView)
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        let text = textView.text.textWithoutSpacePrefix()

        guard !text.contains(Symbols.returnCommand) else {
            let clearText = text.replacingOccurrences(
                of: Symbols.returnCommand,
                with: String.empty)
                textView.text = clearText
                endEditing(true)
            return
        }
    }
}

