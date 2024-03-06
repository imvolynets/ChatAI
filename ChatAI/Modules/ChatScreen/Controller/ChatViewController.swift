//
//  ChatViewController.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Alamofire
import Foundation
import Network
import UIKit

class ChatViewController: UIViewController {
    private let mainView = ChatView()
    private let errorHelper = ErrorHelper()
    private let networkService = NetworkSerivce()
    private var status: NWPath.Status?
    private var isTyping = false
    
    var chat: Chat? {
        didSet {
            mainView.handle(model: chat)
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewController()
    }
    
    private func initViewController() {
        networkService.monitorNetwork()
        addObservers()
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .networkStatus,
            object: nil)
    }
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .networkStatus, object: nil)
    }
}

extension ChatViewController {
    @objc
    private func didKeyboardShow(_ notification: Notification) {
        mainView.tableView.scrollToBottom(animated: false)
    }
    
    @objc
    private func networkStatusChanged(_ notification: Notification) {
        if let connection = notification.object as? NWPath.Status {
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                switch connection {
                case .satisfied:
                    print("conntected")
                    mainView.statusLabel.text = "chat_status_online".localized
                    mainView.messageTextView.isEditable = true
                    mainView.sendButton.isEnabled = true
                    status = .satisfied
                case .unsatisfied:
                    print("disconnected")
                    mainView.statusLabel.text = "chat_status_offline".localized
                    mainView.messageTextView.isEditable = false
                    mainView.sendButton.isEnabled = false
                    mainView.dots.isHidden = true
                    status = .unsatisfied
                case .requiresConnection:
                    break
                @unknown default:
                    break
                }
            }
            }
        }
    }

extension ChatViewController {
    private func setupButtons() {
        mainView.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        mainView.sendButton.addTarget(self, action: #selector(didSendMessageButton), for: .touchUpInside)
    }
    
    private func setupTextView() {
        mainView.messageTextView.delegate = self
    }
    
    private func setupTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.registerReusableCell(UserMessageTableViewCell.self)
        mainView.tableView.registerReusableCell(BotMessageTableViewCell.self)
    }
}

extension ChatViewController {
    @objc
    private func didTapBackButton() {
        if let chat = chat, !chat.messages.isEmpty && chat.messages.last?.role != .assistant {
            DBService.shared.removeUserMessage(chatId: chat.id)
        }
        mainView.messageTextView.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func didSendMessageButton() {
        sendMessage()
    }
}

extension ChatViewController {
    private func sendMessage() {
        mainView.messageTextView.resignFirstResponder()
        guard let chat = chat, let userText = mainView.messageTextView.text else {
            return
        }
        mainView.messageTextView.text = ""
        DBService.shared.addChat(chat: chat)
        let userMessage = Message(id: UUID().uuidString, content: userText, role: .user)
        DBService.shared.addUserMessage(chatId: chat.id, userMessage: userMessage)
        mainView.tableView.insertRow(row: chat.messages.count - 1, animation: .right)
        mainView.tableView.scrollToBottom(animated: true)
        mainView.sendButton.isEnabled = false
        mainView.messageTextView.isEditable = false
        mainView.statusLabel.text = "chat_status_typing".localized
        mainView.dots.isHidden = false
        mainView.dots.animateDots()
        isTyping = true
        APIService.shared.sendStreamMessage(messages: Array(chat.messages)).responseStreamString { [weak self] stream in
            guard let self = self else {
                return
            }
            switch stream.event {
            case .stream(let response):
                streamMessage(response: response)
                
            case .complete(let result):
                finishResponse(result: result)
            }
        }
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
        return chat?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch chat?.messages[indexPath.row].role {
        case .user:
            let cell: UserMessageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.model = chat?.messages[indexPath.row]
            return cell
        case .assistant:
            let cell: BotMessageTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.model = chat?.messages[indexPath.row]
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        if !isTyping {
            switch chat?.messages[indexPath.row].role {
            case .assistant:
                guard tableView.cellForRow(at: indexPath) is BotMessageTableViewCell else {
                    return nil
                }
                return createContextMenu(indexPath: indexPath)
            case .user:
                guard tableView.cellForRow(at: indexPath) is UserMessageTableViewCell else {
                    return nil
                }
                return createContextMenu(indexPath: indexPath)
            case .none:
                break
            }
        }
        return nil
    }
    
    func createContextMenu(indexPath: IndexPath) -> UIContextMenuConfiguration {
        let selectedMessage = chat?.messages[indexPath.row]
        let configuration = UIContextMenuConfiguration(
            identifier: indexPath as NSIndexPath,
            previewProvider: nil) { _ in
                let replyAction = UIAction(
                    title: "Reply",
                    image: UIImage(systemName: "arrowshape.turn.up.left")) { [weak self] _ in
                        guard let self, let chat else {
                            return
                        }
                        var newMessgaes = [Message]()
                        if selectedMessage?.role == .user {
                            if let index = chat.messages.firstIndex(where: { $0.id == selectedMessage?.id }) {
                                newMessgaes = Array(chat.messages.prefix(index + 1))
                            } else {
                                print("Element not found in array")
                            }
                        } else {
                            if let index = chat.messages.firstIndex(where: { $0.id == selectedMessage?.id }) {
                                newMessgaes = Array(chat.messages.prefix(index))
                            } else {
                                print("Element not found in array")
                            }
                        }
                        mainView.sendButton.isEnabled = false
                        mainView.messageTextView.isEditable = false
                        mainView.statusLabel.text = "chat_status_typing".localized
                        mainView.dots.isHidden = false
                        mainView.dots.animateDots()
                        isTyping = true
                        APIService.shared.sendStreamMessage(messages: newMessgaes).responseStreamString { [weak self] stream in
                            guard let self = self else {
                                return
                            }
                            switch stream.event {
                            case .stream(let response):
                                streamMessage(response: response,
                                              selectedMessage: selectedMessage,
                                              indexPath: indexPath,
                                              rewrite: true)
                            case .complete(let result):
                                finishResponse(result: result, rewrite: true)
                            }
                        }
                    }
                
                let copyAction = UIAction(
                    title: "Copy",
                    image: UIImage(systemName: "doc.on.doc")) { [weak self] _ in
                        guard let self else {
                            return
                        }
                        copyMessage(selectedMessage: selectedMessage)
                    }
                
                if self.status == .satisfied {
                   return UIMenu(title: "", image: nil, children: [replyAction, copyAction])
                } else {
                    return UIMenu(title: "", image: nil, children: [copyAction])
                }
            }
        
        return configuration
    }
    
    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else {
            return nil
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? UserMessageTableViewCell {
            return setParametersForContextMenu(cell: cell)
        } else if let cell = tableView.cellForRow(at: indexPath) as? BotMessageTableViewCell {
            return setParametersForContextMenu(cell: cell)
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath else {
            return nil
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? UserMessageTableViewCell {
            return setParametersForContextMenu(cell: cell)
        } else if let cell = tableView.cellForRow(at: indexPath) as? BotMessageTableViewCell {
            return setParametersForContextMenu(cell: cell)
        }
        
        return nil
    }
}

extension ChatViewController {
    private func setParametersForContextMenu<T: BubbleView>(cell: T) -> UITargetedPreview {
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = cell.bubbleView.bezierPath
        
        return UITargetedPreview(view: cell.bubbleView, parameters: parameters)
    }
}

extension ChatViewController {
    private func streamMessage(response: (Result<String, Never>),
                               selectedMessage: Message? = nil,
                               indexPath: IndexPath? = nil,
                               rewrite: Bool = false) {
        guard let chat else {
            return
        }
        switch response {
        case .success(let string):
            let streamResponse = ChatService.shared.parseStreamData(string)
            streamResponse.forEach { newMessageResponse in
                guard let messageContent = newMessageResponse.choices.first?.delta.content else {
                    return
                }
                
                guard let exsistingMessageIndex = chat.messages.lastIndex(
                    where: { $0.id == newMessageResponse.id }
                ) else {
                    if rewrite {
                        ChatService.shared.rewriteBotMessageInDatabase(
                            newMessageResponse: newMessageResponse,
                            messageContent: messageContent,
                            chat: chat,
                            selectedMessage: selectedMessage,
                            indexPathRow: indexPath?.row ?? 0
                        )
                    } else {
                        ChatService.shared.addBotMessageToDatabase(
                            newMessageResponse: newMessageResponse,
                            messageContent: messageContent,
                            chat: chat
                        )
                    }
                    return
                }
                
                ChatService.shared.addMessageToTheExistedMessage(
                    newMessageResponse: newMessageResponse,
                    messageContent: messageContent,
                    chat: chat,
                    exsistingMessageIndex: exsistingMessageIndex
                )
                
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            }
        case .failure(_):
            print("Something got wrong")
        }
    }
    
    func finishResponse(result: DataStreamRequest.Completion, rewrite: Bool = false) {
        if result.response?.statusCode == 429 {
            errorHelper.presentError(
                forError: APIError.reachedResponsesLimit,
                inViewController: self)
            
            if let chat, !rewrite {
                DBService.shared.removeUserMessage(chatId: chat.id)
                mainView.tableView.reloadChats()
            }
        }
        isTyping = false
        mainView.dots.isHidden = true
        mainView.statusLabel.text = "chat_status_online".localized
        mainView.messageTextView.isEditable = true
        print("completed")
    }
    
    private func copyMessage(selectedMessage: Message?) {
        UIPasteboard.general.string = selectedMessage?.content
    }
}
