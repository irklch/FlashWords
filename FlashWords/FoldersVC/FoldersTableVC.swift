//
//  FoldersTableVC.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 05.01.2023.
//

import UIKit
import SnapKit
import Combine
import SwiftExtension

final class FoldersTableVC: UIViewController {
    private let viewModel: FoldersTableViewModel

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = viewModel.title
        titleLabel.font = .avenirBold28
        titleLabel.textColor = Asset.hexFCFCFC.color
        return titleLabel
    }()

    private lazy var addFolderButton: UIButton = {
        let addFolderButton = UIButton()
        addFolderButton.setImage(Images.plus, for: .normal)
        addFolderButton.tintColor = Asset.hexFCFCFC.color
        addFolderButton.addTarget(
            self,
            action: #selector(setAddNewFolder),
            for: .touchUpInside)
        return addFolderButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            FolderTableViewCell.self,
            forCellReuseIdentifier: FolderTableViewCell.withReuseIdentifier)
        tableView.backgroundColor = .clear
        tableView.bounces = true
        tableView.separatorStyle = .none
        tableView.layoutMargins = .init(top: 1, left: 1, bottom: 1, right: 1)

        return tableView
    }()

    private lazy var newFolderTextField: UITextField = {
        let newFolderTextField = UITextField()
        newFolderTextField.backgroundColor = .clear
        newFolderTextField.font = .avenirBold28
        newFolderTextField.textColor = Asset.hexFCFCFC.color
        newFolderTextField.delegate = self
        newFolderTextField.isUserInteractionEnabled = false
        newFolderTextField.returnKeyType = .done
        newFolderTextField.enablesReturnKeyAutomatically = true
        newFolderTextField.autocapitalizationType = .sentences
        return newFolderTextField
    }()

    private var actionObserver: AnyCancellable?

    init(viewModel: FoldersTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.hex333337.color
        navigationItem.titleView = UIView()
        setupViews()
        setupConstraints()
        setupObserver()
        setDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setUpdateData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setCloseEditingMode()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(addFolderButton)
        view.addSubview(tableView)
        view.addSubview(newFolderTextField)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }

        newFolderTextField.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.leading.top.height.equalTo(titleLabel)
        }

        addFolderButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.height.width.equalTo(30)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(15)
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
                case .popToRoot:
                    self.navigationController?.popViewController(animated: true)
                }
            })
    }

    private func setCloseEditingMode() {
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.addFolderButton.setImage(Images.plus, for: .normal)
            self.newFolderTextField.alpha = 0
            self.titleLabel.text = Titles.folders
            self.titleLabel.textColor = Asset.hexFCFCFC.color
            self.titleLabel.alpha = 1
            self.view.layoutIfNeeded()
        }
        newFolderTextField.text = .empty
        newFolderTextField.isUserInteractionEnabled = false
        view.endEditing(true)
        viewModel.isEditingMode = false
    }

    @objc private func setAddNewFolder() {
        guard !viewModel.isEditingMode else {
            if let textFieldText = newFolderTextField.text?.textWithoutSpacePrefix(),
               textFieldText != .empty {
                viewModel.setSaveNewFolder(name: textFieldText)
            }
            setCloseEditingMode()
            return
        }
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.addFolderButton.setImage(Images.checkmark, for: .normal)
            self.titleLabel.text = Titles.newFolderName
            self.titleLabel.textColor = Asset.hex5E5E69.color
            self.newFolderTextField.alpha = 1
            self.view.layoutIfNeeded()
        }
        newFolderTextField.isUserInteractionEnabled = true
        newFolderTextField.becomeFirstResponder()
        viewModel.isEditingMode = true
    }

}

extension FoldersTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Ternary.get(
            if: .value(viewModel.isMovingMode),
            true: .value(1),
            false: .value(2))
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return Ternary.get(
            if: .value((section == 0).and(!viewModel.isMovingMode)),
            true: .value(1),
            false: .value(viewModel.cellsViewModel.count))
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FolderTableViewCell.withReuseIdentifier,
            for: indexPath) as? FolderTableViewCell else {
            return .init(frame: .zero)
        }
        if (indexPath.section == 0).and(!viewModel.isMovingMode) {
            let allWordCount = viewModel.cellsViewModel.reduce(0) { partialResult, folderInfo in
                let result = partialResult.sum(folderInfo.wordsCount)
                return result
            }
            cell.setupView(viewModel: .init(
                name: Titles.allWords,
                wordsCount: allWordCount))
        } else {
            cell.setupView(viewModel: viewModel.cellsViewModel[indexPath.row])
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        guard indexPath.section != 0 else {
            return .none
        }
        return .delete
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard (indexPath.section != 0).and(!viewModel.isMovingMode) else { return nil}
        let editAction: UIContextualAction = .init(style: .destructive, title: .empty) { [weak self] _, view, completion in
            completion(true)
            self?.viewModel.cellsViewModel[safe: indexPath.row]?.uiActions = .shouldChangeName
        }
        editAction.backgroundColor = .systemOrange
        editAction.image = Images.pencil
        let action: UISwipeActionsConfiguration = .init(actions: [editAction])
        action.performsFirstActionWithFullSwipe = false
        return action
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard (indexPath.section != 0).and(!viewModel.isMovingMode) else { return nil}
        let editAction: UIContextualAction = .init(style: .destructive, title: .empty) { [weak self] _, _, _ in
            self?.setCloseEditingMode()
            self?.viewModel.setDeleteFolder(index: indexPath.row)
        }
        editAction.image = Images.trash
        let action: UISwipeActionsConfiguration = .init(actions: [editAction])
        return action
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return .init(frame: .zero)
    }

}

extension FoldersTableVC: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        view.endEditing(true)
        guard !viewModel.isMovingMode else {
            viewModel.setMoveWordTo(index: indexPath.row)
            return
        }
        if indexPath.section != 0 {
            viewModel.setSelectFolder(index: indexPath.row)
        }
        navigationController?.pushViewController(WordListTableVC(), animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 50.0
    }

}

extension FoldersTableVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text?.textWithoutSpacePrefix(),
              !text.contains(Symbols.returnCommand) else {
            let clearText = textField.text?.textWithoutSpacePrefix().replacingOccurrences(
                of: Symbols.returnCommand,
                with: String.empty)
            textField.text = clearText
            view.endEditing(true)
            return
        }

        textField.text = text
        titleLabel.alpha = Ternary.get(
            if: .value(text == .empty),
            true: .value(1),
            false: .value(0))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setAddNewFolder()
        view.endEditing(true)
        return true
    }

}
