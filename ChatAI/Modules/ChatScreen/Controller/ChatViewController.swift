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
        setupTableView()
        setupButtons()
        setupTextView()
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
        mainView.tableView.registerReusableCell(MessageTableViewCell.self)
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
        guard range.location != 0 else {
            return CheckForEmpty.checkForEmpty(textView: textView, range: range, text: text)
        }
        return true
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("+")

        let cell: MessageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.model = messages[indexPath.row]
        return cell
    }
}
