//
//  Message.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation

struct Message {
    let content: String
    let role: SenderRole
}

// test
extension Message {
    // swiftlint:disable all
    static let example = [Message(content: "officiis debitis aut rerum emporibus autem quibusdam aut officiis debitis aut rerum necess itatibus fficiis debitis eveniet?", role: .user), Message(content: "Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus facere possimus, omnis. Temporibus autem quibusdam et aut officiis debitis omnis dolor quo minus id.", role: .assistant), Message(content: "deleniti atque corrupti", role: .user), Message(content: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident.", role: .assistant), Message(content: "Tell me about ancient aborigine ", role: .user)]
    // swiftlint:enable all
}
