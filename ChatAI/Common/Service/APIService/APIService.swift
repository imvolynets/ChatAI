//
//  APIService.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Alamofire
import Foundation

class APIService {
    static let shared = APIService()
    
    private init() { }
    
    func sendStreamMessage(messages: [Message]) -> DataStreamRequest {
        let messages = messages.map({ OpenAIChatMessage(role: $0.role, content: $0.content ) })
        let body = OpenAIChatBody(model: Constants.API.gptModel, messages: messages, stream: true)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.API.key)"
        ]
        
        return AF.streamRequest(Constants.API.url, method: .post, parameters: body, encoder: .json, headers: headers)
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
    let stream: Bool
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

struct ChatStreamCompletionResponse: Decodable {
    let id: String
    let choices: [ChatStreamChoices]
}

struct ChatStreamChoices: Decodable {
    let delta: ChatStreamContent
}

struct ChatStreamContent: Decodable {
    let content: String
}
