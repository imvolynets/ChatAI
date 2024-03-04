//
//  Message.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import Realm
import RealmSwift

class Message: Object {
    @Persisted var id: String
    @Persisted var content: String = ""
    @Persisted var role: SenderRole = .user
    @Persisted(originProperty: "messages")
    var chat: LinkingObjects<Chat>
    @Persisted var timestamp = Date()
    
    convenience init(id: String, content: String, role: SenderRole) {
        self.init()
        self.id = id
        self.content = content
        self.role = role
    }
}
