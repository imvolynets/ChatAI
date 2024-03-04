//
//  SenderRole.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import Realm
import RealmSwift

enum SenderRole: String, Codable, PersistableEnum {
    case assistant
    case user
}
