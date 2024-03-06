//
//  APIError.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 06.03.2024.
//

import Foundation

enum APIError: Error {
    case reachedResponsesLimit
        
    var title: String {
        switch self {
        case .reachedResponsesLimit:
            return "reached_limit_responses_title".localized
        }
    }
    
    var description: String {
        switch self {
        case .reachedResponsesLimit:
            return "reached_limit_responses_description".localized
        }
    }
}
