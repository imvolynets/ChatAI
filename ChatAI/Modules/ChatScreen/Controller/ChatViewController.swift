//
//  ChatViewController.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    private let mainView = ChatView()
    private let messages = Message.example
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }
    
    private func initViewController() {
        setSlideBackFunctionality()
        addObservers()
        setupButtons()
        setupTextView()
        setupTableView()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.mainView.tableView.scrollToBottom(animated: false)
        }
    }
    
    deinit {
        removeObservers()
        print("chatviewcontroller deinit")
    }
}

extension ChatViewController {
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didKeyboardShow(_:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}

extension ChatViewController {
    @objc
    private func didKeyboardShow(_ notification: Notification) {
        mainView.tableView.scrollToBottom(animated: false)
    }
}

extension ChatViewController {
    private func setupButtons() {
        mainView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private func setupTextView() {
        mainView.messageTextView.delegate = self
    }
    
    private func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
//        mainView.tableView.registerReusableCell(MessageTableViewCell.self)
        mainView.tableView.registerReusableCell(UserMessageTableViewCell.self)
        mainView.tableView.registerReusableCell(BotMessageTableViewCell.self)
    }
}

extension ChatViewController {
    @objc 
    private func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

extension ChatViewController: UIGestureRecognizerDelegate {
    private func setSlideBackFunctionality() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension ChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            mainView.messageTextView.invalidateIntrinsicContentSize()
            mainView.messageTextView.placeholderTextView.isHidden = !text.isEmpty
            mainView.sendButton.isEnabled = !text.isEmpty
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.location == 0 {
            return CheckForEmpty.checkForEmpty(textView: textView, range: range, text: text)
        } else if range.location <= Constants.UI.maxMessageSymbols {
            return true
        }
        
        return false
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch messages[indexPath.row].role {
        case .user:
            let cell: UserMessageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.model = messages[indexPath.row]
            return cell
        case .assistant:
            let cell: BotMessageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.model = messages[indexPath.row]
            return cell
        }
    }
}
