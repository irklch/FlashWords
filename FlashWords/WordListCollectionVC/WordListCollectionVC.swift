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
        titleLabel.textColor = Asset.hexF2F2F2.color
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
            left: 20.0,
            bottom: 20.0,
            right: 20.0)
        collectionView.register(
            WordItemCell.self,
            forCellWithReuseIdentifier: WordItemCell.withReuseIdentifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    private static let viewHeight = UIScreen.main.bounds.height
    private static let viewWidth = UIScreen.main.bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.hex2E2C32.color
        setAddColorLayers()
        setAddBlurEffect()
        setupViews()
        setupHeaderConstraints()
        setupCollectionViewConstraints()
        setDismissKeyboardTapGesture()
    }

    private func setupViews() {
        view.addSubview(searchButton)
        view.addSubview(folderButton)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }

    private func setupHeaderConstraints() {
        folderButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
        }
    }

    private func setupCollectionViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
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
        let blueLayer = getColoredLayer(color: Asset.hex3CEAE6.color.cgColor, cornerRadius: 85)
        let redLayer = getColoredLayer(color: Asset.hexFFADAE.color.cgColor, cornerRadius: 125)

        orangedLayer.frame = .init(x: 100, y: 30, width: 200, height: 150)
        blueLayer.frame = .init(x: Self.viewWidth.subtraction(200), y: Self.viewHeight.subtraction(440), width: 150, height: 150)
        redLayer.frame = .init(x: 40, y: Self.viewHeight.subtraction(200), width: 250, height: 250)
        view.layer.addSublayer(orangedLayer)
        view.layer.addSublayer(blueLayer)
        view.layer.addSublayer(redLayer)
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
            width: Self.viewWidth.subtraction(40),
            height: 70.0)
    }
}
