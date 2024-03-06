//
//  Validation.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation
import UIKit

class Validation {
    static func validateChatName(chatName: String, allChats: [Chat]?) throws {
        guard allChats?.filter({ $0.chatName == chatName }).first == nil else {
            throw ValidationError.chatNameAlreadyExist
        }
    }
}
