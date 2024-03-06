//
//  ChatService.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation
import Realm
import RealmSwift

class ChatService {
    static let shared = ChatService()
    
    private init() {}
    
    func searchChat(for searchText: String, in chats: Results<Chat>?) -> Results<Chat>? {
        let format = Constants.DB.searchFormat
        let predicate = NSPredicate(format: format, searchText, searchText)
        return chats?.filter(predicate)
    }
    
    func parseStreamData(_ data: String) -> [ChatStreamCompletionResponse] {
        let responseString = data.components(separatedBy: "data:")
            .map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
            .filter({ !$0.isEmpty })
        
        let jsonDecoder = JSONDecoder()
        return responseString.compactMap { jsonString in
            guard
                let jsonData = jsonString.data(using: .utf8),
                let streamResponse = try? jsonDecoder.decode(ChatStreamCompletionResponse.self, from: jsonData) else {
                return nil
            }
            return streamResponse
        }
    }
    
    func createBotMessage(newMessageResponse: ChatStreamCompletionResponse, messageContent: String) -> Message {
        return Message(id: newMessageResponse.id, content: messageContent, role: .assistant)
    }
    
    func addBotMessageToDatabase(newMessageResponse: ChatStreamCompletionResponse, messageContent: String, chat: Chat) {
        let newMessage = createBotMessage(newMessageResponse: newMessageResponse, messageContent: messageContent)
        DBService.shared.addBotMessgae(chatId: chat.id, botMessage: newMessage)
    }
    
    func rewriteBotMessageInDatabase(newMessageResponse: ChatStreamCompletionResponse, 
                                     messageContent: String,
                                     chat: Chat,
                                     selectedMessage: Message?,
                                     indexPathRow: Int) {
        let newMessage = createBotMessage(newMessageResponse: newMessageResponse, messageContent: messageContent)
        DBService.shared.rewriteBotMessgae(chatId: chat.id, 
                                           botMessage: newMessage,
                                           indexMessage: selectedMessage?.role == .user ?
                                           indexPathRow + 1 : indexPathRow)
    }
    
    func addMessageToTheExistedMessage(
        newMessageResponse: ChatStreamCompletionResponse,
        messageContent: String,
        chat: Chat?,
        exsistingMessageIndex: Int
    ) {
        guard let chat else {
            return
        }
        let newMessage = Message(
            id: newMessageResponse.id,
            content: (chat.messages[exsistingMessageIndex].content) + messageContent,
            role: .assistant
        )
        DBService.shared.addToExistingBotMessage(
            chatId: chat.id,
            existIndex: exsistingMessageIndex,
            newMessage: newMessage
        )
    }
}
