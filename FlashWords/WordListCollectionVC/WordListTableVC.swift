//
//  WordListTableVC.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 14.12.2022.
//

import UIKit
import SnapKit
import Combine
import SwiftExtension

final class WordListTableVC: UIViewController {
    private let viewModel: WordListTableViewModel = .init()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Ternary.get(
            if: .value(viewModel.isAllWordsFolder),
            true: .value(Titles.allWords),
            false: .value(viewModel.selectedFolderInfo.folderName)) 
        titleLabel.font = .avenirBold28
        titleLabel.textColor = Asset.hexFCFCFC.color
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            WordTableViewCell.self, 
            forCellReuseIdentifier: WordTableViewCell.withReuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.bounces = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Asset.hexFCFCFC.color
        tableView.separatorInset = .zero
        return tableView
    }()

    private lazy var inputTextView: NewWordInputView = .init(viewModel: viewModel.inputTextViewModel)
    private var observersManager = AnyCancellableManager<Observers>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.hex333337.color
        setupNavigationBar()
        setupViews()
        setupHeaderConstraints()
        setupCollectionAndInputViewConstraints()
        setupMainThreadObserver()
        setupInputTextViewObserver()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setUpdateData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        if isMovingFromParent {
            viewModel.setDeselectFolder()
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = Asset.hexFCFCFC.color
        navigationController?.navigationBar.backItem?.title = Titles.folders
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }

    private func setupHeaderConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
    }

    private func setupCollectionAndInputViewConstraints() {
        let inputViewHeight = Ternary.get(
            if: .value(viewModel.isAllWordsFolder),
            true: .value(0.0),
            false: .value(viewModel.inputTextViewModel.initialHeight))
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-inputViewHeight)
        }
        if !viewModel.isAllWordsFolder {
            view.addSubview(inputTextView)
            inputTextView.snp.makeConstraints { make in
                make.bottom.leading.trailing.equalToSuperview()
                make.height.equalTo(inputViewHeight)
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    private func setupMainThreadObserver() {
       let mainThreadObserver = viewModel
            .$mainThreadActionsState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
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
            }
        observersManager.setValue(type: .mainThreadActionsState, value: mainThreadObserver)
    }

    private func setupInputTextViewObserver() {
        let inputTextViewObserver = viewModel
            .inputTextViewModel
            .$mainThreadActionsState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .subscriptionAction:
                    break
                case .updateHeight(
                    let keyboardHeight,
                    let viewHeight):
                    UIView.animate(withDuration: 0.3) { [weak self] in
                        guard let self = self else { return }
                        self.tableView.snp.updateConstraints { make in
                            make.bottom.equalToSuperview().offset(-viewHeight.sum(keyboardHeight))
                        }
                        self.inputTextView.snp.updateConstraints { make in
                            make.height.equalTo(viewHeight+keyboardHeight)
                        }
                    }
                case .hideNavigationBar:
                    self?.navigationController?.navigationBar.isHidden = true
                case .showNavigationBar:
                    self?.navigationController?.navigationBar.isHidden = false
                }
            }
        observersManager.setValue(
            type: .inputTextView,
            value: inputTextViewObserver)
    }

}

extension WordListTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Ternary.get(
            if: .value(viewModel.isAllWordsFolder),
            true: .value(viewModel.allFoldersInfo.count),
            false: .value(1))
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        let allWordsSectionCount = (viewModel.allFoldersInfo[safe: section]?.wordsModel.count).nonOptional()
        return Ternary.get(
            if: .value(viewModel.isAllWordsFolder),
            true: .value(allWordsSectionCount),
            false: .value(viewModel.selectedFolderInfo.wordsModel.count))
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: WordTableViewCell.withReuseIdentifier,
            for: indexPath) as? WordTableViewCell else {
            return .init(frame: .zero)
        }
        let allWordsData = (viewModel.allFoldersInfo[safe: indexPath.section]?
            .wordsModel.reversed()[safe: indexPath.row]
        ).nonOptional(.emptyModel)
        let selectedWordsData = (viewModel.selectedFolderInfo
            .wordsModel.reversed()[safe: indexPath.row]
        ).nonOptional(.emptyModel)

        let wordForeignTitle = Ternary.get(
            if: .value(viewModel.isAllWordsFolder),
            true: .value(allWordsData.foreignWord),
            false: .value(selectedWordsData.foreignWord))
        let wordNativeTitle = Ternary.get(
            if: .value(viewModel.isAllWordsFolder),
            true: .value(allWordsData.nativeWord),
            false: .value(selectedWordsData.nativeWord))
        cell.setupView(viewModel: .init(foreignWord: wordForeignTitle, nativeWord: wordNativeTitle))

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let selectedFolderDeletedWordRowIndex = viewModel.selectedFolderInfo.wordsModel
            .count
            .subtraction(1)
            .subtraction(indexPath.row)
        guard let wordModel = viewModel.selectedFolderInfo.wordsModel[safe: selectedFolderDeletedWordRowIndex] else { return nil }
        let viewModel: FoldersTableViewModel = .init(
            title: Titles.chooseFolder,
            isMovingMode: true,
            movingFromFolderId: viewModel.selectedFolderInfo.id,
            movingWordId: wordModel.id)
        let vc = FoldersTableVC(viewModel: viewModel)
        let editAction: UIContextualAction = .init(style: .normal, title: .empty) { [weak self] _, _, _ in
            self?.navigationController?.pushViewController(
                vc, 
                animated: true)
        }
        editAction.backgroundColor = .blue
        editAction.image = Images.folder
        let action: UISwipeActionsConfiguration = .init(actions: [editAction])
        return action
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        let selectedFolderDeletedWordRowIndex = viewModel.selectedFolderInfo.wordsModel
            .count
            .subtraction(1)
            .subtraction(indexPath.row)
        let allWordDeletedWordRowIndex = (viewModel.allFoldersInfo[safe: indexPath.section]?.wordsModel
            .count
            .subtraction(1)
            .subtraction(indexPath.row)
        ).nonOptional()
        let selectedFolderWordIndexPath: IndexPath = .init(
            row: selectedFolderDeletedWordRowIndex,
            section: indexPath.section)
        let allWordsWordIndexPath: IndexPath = .init(
            row: allWordDeletedWordRowIndex,
            section: indexPath.section)
        
        viewModel.setDeleteItemWith(indexPath: Ternary.get(
            if: .value(viewModel.isAllWordsFolder),
            true: .value(allWordsWordIndexPath),
            false: .value(selectedFolderWordIndexPath)))
    }
}

extension WordListTableVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 82.0
    }
    
}
