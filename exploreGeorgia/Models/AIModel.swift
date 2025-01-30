//
//  AIModel.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import SwiftUI

struct BodyModel: Codable {
    let model: String
    let messages: [MessageModel]
}

struct MessageModel: Codable {
    let role: String
    let content: String
}

struct ChatCompletionResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let prompt: [String]?
    let choices: [Choice]
}

struct Choice: Codable {
    let finishReason: String
    let seed: UInt64?
    let logprobs: String?
    let index: Int
    let message: Message

    enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case seed, logprobs, index, message
    }
}

struct Message: Codable {
    let role: String
    let content: String
    let toolCalls: [String]?

    enum CodingKeys: String, CodingKey {
        case role, content
        case toolCalls = "tool_calls"
    }
}
