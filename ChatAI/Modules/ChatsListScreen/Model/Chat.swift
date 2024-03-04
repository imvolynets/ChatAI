//
//  Chat.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import Realm
import RealmSwift
import UIKit

class Chat: Object {
    @Persisted(primaryKey: true)
    var id: ObjectId
    @Persisted var chatName = ""
    @Persisted var lastMessage: String?
    @Persisted var messages = RealmSwift.List<Message>()
    @Persisted var avatarColor = ""
    @Persisted var lastMessageTimestamp: Date?
    
    convenience init(chatName: String) {
        self.init()
        self.chatName = chatName
        self.avatarColor = generateRandomColor()
    }
    
    private func generateRandomColor() -> String {
        let red = CGFloat.random(in: 0...0.9)
        let green = CGFloat.random(in: 0...0.9)
        let blue = CGFloat.random(in: 0...0.9)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        let hexString = color.toHex()
        
        return hexString
    }
}
