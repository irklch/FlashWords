//
//  NewWordInputView.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 03.01.2023.
//

import UIKit
import SnapKit
import Combine

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
        foreignTextView.textContainerInset = .init(
            top: 8.0,
            left: 8.0,
            bottom: 0.0,
            right: 8.0)
        foreignTextView.text = Titles.foreignWord
        foreignTextView.delegate = self
        foreignTextView.isScrollEnabled = false
        return foreignTextView
    }()

    private lazy var nativeTextView: UITextView = {
        let nativeTextView = UITextView()
        nativeTextView.backgroundColor = .clear
        nativeTextView.font = .avenirRegular16
        nativeTextView.textColor = Asset.hex7A7A7E.color
        nativeTextView.showsVerticalScrollIndicator = false
        nativeTextView.textContainerInset = .init(
            top: 8.0,
            left: 8.0,
            bottom: 0.0,
            right: 8.0)
        nativeTextView.text = Titles.nativeWord
        nativeTextView.delegate = self
        nativeTextView.isScrollEnabled = false
        nativeTextView.alpha = 0
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
        separatorLineLayer.isHidden = true
        return separatorLineLayer
    }()

    private var actionsObserver: AnyCancellable?

    init(viewModel: NewWordInputViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupViewsConstraints()
        setupSeparatorLineLayer()
        setupObserver()
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
    }

    private func setupViewsConstraints() {
        inputBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .inset(NewWordInputViewOffsets.inputBackgroundViewTopOffset)
            make.leading.trailing.equalToSuperview()
                .inset(NewWordInputViewOffsets.inputViewLeadingTrailingOffset)
            make.height.equalTo(NewWordInputViewOffsets.inputBackgroundViewClosedHeight)
        }

        foreignTextView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(NewWordInputViewOffsets.textViewClosedHeight)
        }

        nativeTextView.snp.makeConstraints { make in
            make.top.equalTo(foreignTextView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(NewWordInputViewOffsets.textViewOpenedHeight)
        }

        addWordButton.snp.makeConstraints { make in
            make.top.equalTo(inputBackgroundView.snp.bottom)
                .offset(NewWordInputViewOffsets.addWordButtonTopOffset)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(NewWordInputViewOffsets.addWordButtonHeight)
            make.width.equalTo(65)
        }
    }

    private func setupSeparatorLineLayer() {
        let layerWidth: CGFloat = UIScreen.main.bounds.width
            .subtraction(NewWordInputViewOffsets.inputViewLeadingTrailingOffset)
            .subtraction(NewWordInputViewOffsets.inputViewLeadingTrailingOffset)
            .subtraction(32)
        let layerY: CGFloat = NewWordInputViewOffsets.inputBackgroundViewTopOffset
            .sum(NewWordInputViewOffsets.textViewOpenedHeight)
        inputBackgroundView.layer.addSublayer(separatorLineLayer)
        separatorLineLayer.frame = .init(
            x: 16.0,
            y: layerY,
            width: layerWidth,
            height: 1.0)
    }

    @objc private func setAddWordInVocabulary() {
#warning("добавить событие добавления")
    }

    private func setupObserver() {
        actionsObserver = viewModel
            .$actionsState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .subscriptionAction,
                        .addedWord:
                    break
                case .viewSelected:
                    self?.setOpenTextViews()
                case .viewDeselected:
                    self?.setCloseTextViews()
                }
            })
    }

    private func setOpenTextViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.inputBackgroundView.snp.updateConstraints { make in
                make.height.equalTo(NewWordInputViewOffsets.inputBackgroundViewOpenedHeight)
            }

            self.foreignTextView.snp.updateConstraints { make in
                make.height.equalTo(NewWordInputViewOffsets.textViewOpenedHeight)
            }

            self.nativeTextView.alpha = 1
            self.addWordButton.alpha = 1
            self.separatorLineLayer.isHidden = false
            self.layoutIfNeeded()
        }
    }

    private func setCloseTextViews() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.inputBackgroundView.snp.updateConstraints { make in
                make.height.equalTo(NewWordInputViewOffsets.inputBackgroundViewClosedHeight)
            }

            self.foreignTextView.snp.updateConstraints { make in
                make.height.equalTo(NewWordInputViewOffsets.textViewClosedHeight)
            }

            self.nativeTextView.alpha = 0
            self.addWordButton.alpha = 0
            self.separatorLineLayer.isHidden = true
            self.layoutIfNeeded()
        }
    }
}

extension NewWordInputView: UITextViewDelegate {
    #warning("добавить расчёт высоты")

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        setOpenTextViews()
        if textView.textColor == Asset.hex7A7A7E.color {
            textView.textColor = Asset.hexF2F2F2.color
            textView.text = .empty
            textView.isScrollEnabled = true
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        setCloseTextViews()
        if textView.text == .empty {
            textView.textColor = Asset.hex7A7A7E.color
            textView.text = Titles.foreignWord
            textView.isScrollEnabled = false
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        let text = textView.text.nonOptional().textWithoutSpacePrefix()

        guard !text.contains(Symbols.returnCommand) else {
            let clearText = text.replacingOccurrences(
                of: Symbols.returnCommand,
                with: String.empty)

//            if clearText == .empty {
                textView.text = clearText
                endEditing(true)
//            } else {
//                viewModel.newWordModel.wordsModel
//            }
            return
        }
    }
}

enum NewWordInputViewOffsets {
    static let textViewClosedHeight: CGFloat = 35.0
    static let textViewOpenedHeight: CGFloat = 58.0
    static let inputBackgroundViewClosedHeight: CGFloat = 35.0
    static let inputBackgroundViewOpenedHeight: CGFloat = 116.0
    static let inputBackgroundViewTopOffset: CGFloat = 8.0
    static let addWordButtonTopOffset: CGFloat = 12.0
    static let addWordButtonHeight: CGFloat = 30.0
    static let addWordButtonBottomOffset: CGFloat = 12.0
    static let viewClosedBottomOffset: CGFloat = 20.0
    static let inputViewLeadingTrailingOffset: CGFloat = 16.0
}
