//
//  DBService.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation
import Realm
import RealmSwift

class DBService {
    static let shared = DBService()
    private var realm: Realm
    
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            print("Error initializing Realm: \(error.localizedDescription)")
            fatalError("Unable to initialize Realm")
        }
    }
    
    func fetchChats() -> Results<Chat> {
        return realm.objects(Chat.self).sorted(byKeyPath: "lastMessageTimestamp", ascending: false)
    }
    
    func getChatByID(chatId: ObjectId) -> Chat? {
        return fetchChats().filter("id == %@", chatId).first
    }
    
    func addChat(chat: Chat) {
        do {
            try realm.write {
                realm.add(chat)
            }
        } catch {
            print("Error saving chat: \(error.localizedDescription)")
        }
    }
    
    func addBotMessgae(chatId: ObjectId, botMessage: Message) {
        let chat = getChatByID(chatId: chatId)
        
        do {
            try realm.write {
                chat?.messages.append(botMessage)
                chat?.lastMessage = botMessage.content
                chat?.lastMessageTimestamp = Date()
            }
        } catch {
            print("Error adding bot's message: \(error.localizedDescription)")
        }
    }
    
    func addToExistingBotMessage(chatId: ObjectId, existIndex: Int, newMessage: Message) {
        let chat = getChatByID(chatId: chatId)
        
        do {
            try realm.write {
                chat?.messages[existIndex] = newMessage
                chat?.lastMessage = newMessage.content
                chat?.lastMessageTimestamp = Date()
            }
        } catch {
            print("Error adding existing message: \(error.localizedDescription)")
        }
    }
    
    func addUserMessage(chatId: ObjectId, userMessage: Message) {
        let chat = getChatByID(chatId: chatId)
        
        do {
            try realm.write {
                chat?.messages.append(userMessage)
            }
        } catch {
            print("Error adding user's message: \(error.localizedDescription)")
        }
    }
    
    func removeUserMessage(chatId: ObjectId) {
        let chat = getChatByID(chatId: chatId)

        do {
            try realm.write {
                chat?.messages.removeLast()
            }
        } catch {
            print("Error removing chat message: \(error.localizedDescription)")
        }
    }
    
    func deleteChat(chat: Chat) {
        do {
            try realm.write {
                realm.delete(chat)
            }
        } catch {
            print("Error deleting chat: \(error.localizedDescription)")
        }
    }
    
    func rewriteBotMessgae(chatId: ObjectId, botMessage: Message, indexMessage: Int) {
        let chat = getChatByID(chatId: chatId)
        
        do {
            try realm.write {
                chat?.messages[indexMessage] = botMessage
                chat?.lastMessage = botMessage.content
                chat?.lastMessageTimestamp = Date()
            }
        } catch {
            print("Error rewriting bot's message: \(error.localizedDescription)")
        }
    }
}
