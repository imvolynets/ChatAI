//
//  Constants.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation

struct Constants {
    // swiftlint: disable all
    struct UI {
        static let maxSearchSymbols = 40
        static let maxChatNameSymbols = 15
        static let maxMessageSymbols = 1000
    }
    
    struct API {
        static let key = "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"
        static let gptModel = "gpt-3.5-turbo"
        static let url = "https://api.openai.com/v1/chat/completions"
    }
    
    struct DB {
        static let searchFormat = "chatName CONTAINS[c] %@ OR ANY messages.content CONTAINS[c] %@"
    }
    // swiftlint: enable all
}
