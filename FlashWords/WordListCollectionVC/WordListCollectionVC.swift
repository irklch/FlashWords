//
//  WordListCollectionVC.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 14.12.2022.
//

import UIKit
import SnapKit

final class WordListCollectionVC: UIViewController {
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
        return searchButton
    }()

    private lazy var folderButton: UIButton = {
        let folderButton = UIButton()
        folderButton.setImage(Images.folder, for: .normal)
        folderButton.addTarget(
            self,
            action: #selector(setSearchButtonAction),
            for: .touchUpInside)
        return folderButton
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionFlow = UICollectionViewFlowLayout()
        collectionFlow.scrollDirection = .vertical
        collectionFlow.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlow)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = .init(
            top: 0.0,
            left: 20.0,
            bottom: 0.0,
            right: 20.0)
        collectionView.register(
            NavBarCollectionItemsCell.self,
            forCellWithReuseIdentifier: NavBarCollectionItemsCell.withReuseIdentifier)
        collectionView.backgroundColor = Asset.hexFFFFFF.color
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = Asset.hex1D1C21.color
        view.addSubview(titleLabel)
        view.addSubview(searchButton)
        view.addSubview(folderButton)

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(100)
        }

        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-12)
        }

        folderButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-12)
        }

    }

    @objc private func setSearchButtonAction() {

    }


}

