//
//  WordListTableVC.swift
//  FlashWords
//
//  Created by Ирина Кольчугина on 14.12.2022.
//

import UIKit
import SnapKit
import Combine

final class WordListTableVC: UIViewController {
    private let viewModel: WordListTableViewModel = .init()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = Titles.newListName
        titleLabel.font = .avenirBold36
        titleLabel.textColor = Asset.hexFCFCFC.color
        return titleLabel
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

    private lazy var newWordInputView: NewWordInputView = .init(viewModel: viewModel.inputTextViewModel)
    private var mainThreadObserver: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.hex333337.color
        setupViews()
        setupHeaderConstraints()
        setupCollectionAndInputViewConstraints()
        setupObserver()
        setKeyboardNotifications()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addListButton)
        view.addSubview(newWordInputView)
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

    private func setupCollectionAndInputViewConstraints() {
        let inputViewHeight = viewModel.inputTextViewModel.getViewHeight(isOpened: false)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-inputViewHeight)
        }

        newWordInputView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(inputViewHeight)
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
        viewModel.inputTextViewModel.mainThreadActionsState = .viewSelected
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            let inputViewOpenedHeight = self.viewModel.inputTextViewModel.getViewHeight(isOpened: true)
            let inputViewHeightWithKeyboard = keyboardSize.height.sum(inputViewOpenedHeight)
            self.newWordInputView.snp.updateConstraints { make in
                make.height.equalTo(inputViewHeightWithKeyboard)
            }

            self.tableView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-inputViewHeightWithKeyboard)
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc private func setKeyboardWillHide(_ notification: Notification) {
        viewModel.inputTextViewModel.mainThreadActionsState = .viewDeselected
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            let inputViewClosedHeight = self.viewModel.inputTextViewModel.getViewHeight(isOpened: false)
            self.newWordInputView.snp.updateConstraints { make in
                make.height.equalTo(inputViewClosedHeight)
            }
            self.tableView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(-inputViewClosedHeight)
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc private func setAddNewList() {
#warning("добавить событие добавления листа")
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    private func setupObserver() {
       mainThreadObserver = viewModel
            .$mainThreadActionsState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .subscriptionAction:
                    break
                case .reloadData:
                    self?.tableView.reloadData()
                }
            }
    }

}

extension WordListTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.selectedListData.wordsModel.count
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
              let wordsData = viewModel.selectedListData.wordsModel.reversed()[safe: indexPath.section] else {
            return .init(frame: .zero)
        }
        cell.setupView(viewModel: .init(data: wordsData))
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
        return 50.0
    }
    
}
