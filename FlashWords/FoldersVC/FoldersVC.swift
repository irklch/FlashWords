//
//  FoldersVC.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 05.01.2023.
//

import UIKit
import SnapKit
import Combine

final class FoldersVC: UIViewController {
    private let viewModel: FoldersViewModel = .init()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Titles.folders
        titleLabel.font = .avenirBold28
        titleLabel.textColor = Asset.hexFCFCFC.color
        return titleLabel
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

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            WordItemCell.self,
            forCellReuseIdentifier: WordItemCell.withReuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.bounces = true
        tableView.separatorStyle = .none
        return tableView
    }()

    private var actionObserver: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.hex333337.color
        navigationItem.titleView = UIView()
        setupViews()
        setupConstraints()
        setupObserver()
    }
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(addListButton)
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        addListButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.width.equalTo(30)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    private func setupObserver() {
        actionObserver = viewModel
            .$mainThreadActionState
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .subscriptionAction:
                    break
                case .reloadData:
                    self?.tableView.reloadData()
                }
            })
    }

    @objc private func setAddNewList() {
#warning("добавить событие добавления листа")
    }

}

extension FoldersVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.foldersData.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WordItemCell.withReuseIdentifier,
            for: indexPath) as? WordItemCell,
              let foldersData = viewModel.foldersData.reversed()[safe: indexPath.section] else {
            return .init(frame: .zero)
        }
        cell.setupView(viewModel: .init(name: foldersData.folderName))
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        return 10
    }

    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        let wordIndex = viewModel.foldersData.count
            .subtraction(1)
            .subtraction(indexPath.section)
//        viewModel.setDeleteItemWith(index: wordIndex)
    }
}

extension FoldersVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let folderIndex = viewModel.foldersData.count
            .subtraction(1)
            .subtraction(indexPath.section)
        viewModel.setSelectFolder(index: folderIndex)
        navigationController?.pushViewController(WordListTableVC(), animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 50.0
    }

}

