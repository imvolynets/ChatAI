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
    private var addChatAlert: UIAlertController?
    
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
        setupButtons()
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
    
    private func setupButtons() {
        mainView.addNewChatButton.addTarget(self, action: #selector(didTapAddNewChat), for: .touchUpInside)
    }
}

extension ChatsListViewController {
    @objc
    private func didTapAddNewChat() {
        if addChatAlert == nil {
            addChatAlert = createAddChatAlert()
            setupAddChatAlert(addChatAlert: addChatAlert)
        }
        
        if let addChatAlert {
            presentAddChatAlert(addChatAlert: addChatAlert)
        }
    }
}

extension ChatsListViewController {
    private func openChat() {
        let chatViewController = ChatViewController()
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}

extension ChatsListViewController {
    private func createAddChatAlert() -> UIAlertController {
        return UIAlertController(
            title: String(localized: "create_chat_alert_title"),
            message: String(localized: "create_chat_alert_desc"),
            preferredStyle: .alert
        )
    }
    
    private func setupAddChatAlert(addChatAlert: UIAlertController?) {
        guard let addChatAlert else {
            return
        }

        addChatAlert.addTextField { textField in
            textField.delegate = self
            textField.addTarget(
                self,
                action: #selector(self.textFieldDidChange(_:)),
                for: .editingChanged
            )
        }

        addChatAlert.addAction(UIAlertAction(
            title: String(localized: "create_chat_alert_create_btn"),
            style: .default
        ) { _ in
            guard let textField = addChatAlert.textFields?.first else {
                return
            }
            
            if let newChatName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                textField.text = ""
                self.openChat()
            }
        })
        
        addChatAlert.addAction(UIAlertAction(
            title: String(localized: "create_chat_alert_cancel_btn"),
            style: .cancel,
            handler: nil)
        )
    }
    
    private func presentAddChatAlert(addChatAlert: UIAlertController) {
        let textCount = addChatAlert.textFields?.first?.text?.count ?? 0
        addChatAlert.actions.first?.isEnabled = textCount <= 15 && textCount > 0
        present(addChatAlert, animated: true, completion: nil)
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        let characterLimit = 15
        
        if let text = textField.text, text.count > characterLimit {
            let truncatedText = String(text.prefix(characterLimit))
            textField.text = truncatedText
        }
        
        if let alertController = presentedViewController as? UIAlertController {
            let textCount = textField.text?.count ?? 0
            alertController.actions.first?.isEnabled = textCount <= 15 && textCount > 0
        }
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
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        return true
    }
}

extension ChatsListViewController {
    private func deselectRow() {
        if let selectedIndexPath = mainView.tableView.indexPathForSelectedRow {
            mainView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}
