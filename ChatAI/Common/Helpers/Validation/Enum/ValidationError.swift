//
//  ValidationError.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation

enum ValidationError: Error {
    case chatNameAlreadyExist
    
    var title: String {
        switch self {
        case .chatNameAlreadyExist:
            return "chat_create_validation_error_title".localized
        }
    }
        
    var description: String {
        switch self {
        case .chatNameAlreadyExist:
            return "chat_name_exist_error".localized
        }
    }
}
