//
//  FoldersVC.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 05.01.2023.
//

import UIKit
import SnapKit
import Combine
import SwiftExtension

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

    private lazy var newFolderTextView: UITextView = {
        let newFolderTextView = UITextView()
        newFolderTextView.backgroundColor = .clear
        newFolderTextView.font = .avenirBold28
        newFolderTextView.textColor = Asset.hexFCFCFC.color
        newFolderTextView.showsVerticalScrollIndicator = false
        newFolderTextView.textContainerInset = .zero
        newFolderTextView.delegate = self
        newFolderTextView.isScrollEnabled = false
        newFolderTextView.isUserInteractionEnabled = false
        return newFolderTextView
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

    override func viewWillAppear(_ animated: Bool) {
        viewModel.setUpdateData()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(addListButton)
        view.addSubview(tableView)
        view.addSubview(newFolderTextView)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        newFolderTextView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.top.height.equalTo(titleLabel)
            make.leading.equalToSuperview().offset(13)
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
                guard let self = self else { return }
                switch state {
                case .subscriptionAction:
                    break
                case .reloadData:
                    UIView.transition(
                        with: self.tableView,
                        duration: 0.1,
                        options: .transitionCrossDissolve,
                        animations: { [weak self] in
                            self?.tableView.reloadData()
                        }, completion: nil)
                }
            })
    }

    @objc private func setAddNewList() {
        if addListButton.currentImage == Images.plus {
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.addListButton.setImage(Images.checkmark, for: .normal)
                self?.titleLabel.text = "New folder name"
                self?.titleLabel.textColor = Asset.hex5E5E69.color
                self?.newFolderTextView.alpha = 1
                self?.view.layoutIfNeeded()
            }
            newFolderTextView.isUserInteractionEnabled = true
            newFolderTextView.becomeFirstResponder()
        } else {
            if newFolderTextView.text.textWithoutSpacePrefix() != .empty {
                viewModel.setSaveNewFolder(name: newFolderTextView.text.textWithoutSpacePrefix())
            }
            UIView.animate(withDuration: 0.1) { [weak self] in
                self?.addListButton.setImage(Images.plus, for: .normal)
                self?.newFolderTextView.alpha = 0
                self?.titleLabel.text = Titles.folders
                self?.titleLabel.textColor = Asset.hexFCFCFC.color
                self?.titleLabel.alpha = 1
                self?.view.layoutIfNeeded()
            }
            newFolderTextView.text = .empty
            newFolderTextView.isUserInteractionEnabled = false
            view.endEditing(true)
        }
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
              let foldersData = viewModel.foldersData[safe: indexPath.section] else {
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
        viewModel.setDeleteFolder(index: indexPath.section)
    }
}

extension FoldersVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        view.endEditing(true)
        viewModel.setSelectFolder(index: indexPath.section)
        navigationController?.pushViewController(WordListTableVC(), animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 50.0
    }

}

extension FoldersVC: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == Asset.hex7A7A7E.color {
            textView.textColor = Asset.hexF2F2F2.color
            textView.text = .empty
            textView.isScrollEnabled = true
        }
        return true
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        let text = textView.text.textWithoutSpacePrefix()
        textView.text = text
        guard !text.contains(Symbols.returnCommand) else {
            let clearText = text.replacingOccurrences(
                of: Symbols.returnCommand,
                with: String.empty)
                textView.text = clearText
            view.endEditing(true)
            return
        }

        titleLabel.alpha = Ternary.get(
            if: .value(text == .empty),
            true: .value(1),
            false: .value(0))
    }
}
