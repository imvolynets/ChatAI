//
//  ViewController.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import Realm
import RealmSwift
import UIKit

class ChatsListViewController: UIViewController {
    private let mainView = ChatsListView()
    private var addChatAlert: UIAlertController?
    
    private var allChats: Results<Chat>?
    private var filteredChats: Results<Chat>?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFilteredChats()
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
        loadChatsFromDataBase()
        setupSearchField()
        setupTableView()
        setupButtons()
    }
}

extension ChatsListViewController {
    private func setFilteredChats() {
        if let text = mainView.searchField.text, text.isEmpty {
            filteredChats = allChats
        }
        self.mainView.tableView.reloadChats()
    }
}

extension ChatsListViewController {
    private func loadChatsFromDataBase() {
        allChats = DBService.shared.fetchChats()
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
    private func openChat(existedChat: Chat? = nil, chatName: String = "") {
        let chatViewController = ChatViewController()
        
        if let existedChat {
            chatViewController.chat = allChats?.first(where: { $0.id == existedChat.id })
        } else {
            chatViewController.chat = Chat(chatName: chatName)
        }
        
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
            
            if let chatName = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if self.performValidationChatName(chatName: chatName) {
                    textField.text = ""
                    self.openChat(chatName: chatName)
                }
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
            alertController.actions.first?.isEnabled = textCount <= Constants.UI.maxChatNameSymbols && textCount > 0
        }
    }
}

extension ChatsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredChats?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = filteredChats?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openChat(existedChat: filteredChats?[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, 
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _, completionHandler in 
            let confirmAlert = UIAlertController(
                title: "confirm_delete_alert_title".localized,
                message: "",
                preferredStyle: .alert)
            
            confirmAlert.addAction(UIAlertAction(
                title: "confirm_delete_alert_confirm".localized,
                style: .default
            ) { _ in
                if let chat = self.filteredChats?[indexPath.row] {
                    DBService.shared.deleteChat(chat: chat)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.mainView.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
            confirmAlert.addAction(UIAlertAction(title: "confirm_delete_alert_cancel".localized,
                                                 style: .cancel) { _ in
                completionHandler(true)
            })
            
            self.present(confirmAlert, animated: true, completion: nil)
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
}

extension ChatsListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mainView.searchField {
            mainView.searchPlaceholderLabel.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mainView.searchField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, textField == mainView.searchField {
            mainView.searchPlaceholderLabel.isHidden = !text.isEmpty
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        
        if textField == mainView.searchField {
            if range.location <= Constants.UI.maxSearchSymbols {
                guard let searchText = (textField.text as? NSString)?
                    .replacingCharacters(in: range, with: string) else {
                    return false
                }
                filteredChats = ChatService.shared.searchChat(for: searchText, in: allChats)
                if let filteredChats = filteredChats, searchText.isEmpty, filteredChats.isEmpty {
                    self.filteredChats = allChats
                }
                mainView.tableView.reloadChats()
                return true
            }
            return false
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.filteredChats = allChats
            self.mainView.tableView.reloadData()
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

extension ChatsListViewController {
    private func performValidationChatName(chatName: String) -> Bool {
        guard let allChats else {
            return false
        }
        do {
            try Validation.validateChatName(chatName: chatName, allChats: Array(allChats))
        } catch let error as ValidationError {
            let alert = ErrorAlert.showAlertError(
                title: "chat_create_validation_error_title".localized,
                message: error.localizedDescription
            )
            present(alert, animated: true, completion: nil)
            return false
        } catch {
            print("An unexcepted error occured")
        }
        return true
    }
}
