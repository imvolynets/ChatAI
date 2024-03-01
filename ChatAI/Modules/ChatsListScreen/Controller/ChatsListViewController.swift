//
//  ViewController.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import UIKit

class ChatsListViewController: UIViewController {
    private let mainView = ChatsListView()
    private let chats = Chat.example
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deselectRow()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.addLeftPaddingToSearchField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }
    
    private func initViewController() {
        setupSearchField()
        setupTableView()
    }
}

extension ChatsListViewController {
    private func setupTableView() {
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.registerReusableCell(ChatsTableViewCell.self)
    }
    
    private func setupSearchField() {
        mainView.searchField.delegate = self
    }
}

extension ChatsListViewController {
    private func openChat() {
        let chatViewController = ChatViewController()
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}

extension ChatsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chat.example.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = chats[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openChat()
    }
}

extension ChatsListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.searchPlaceholderLabel.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mainView.searchField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            mainView.searchPlaceholderLabel.isHidden = !text.isEmpty
        }
    }
}

extension ChatsListViewController {
    private func deselectRow() {
        if let selectedIndexPath = mainView.tableView.indexPathForSelectedRow {
            mainView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}
