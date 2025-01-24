//
//  AIViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

//
//  GameModel.swift
//  35. Emoji Riddler
//
//  Created by Despo on 29.12.24.
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




import Combine
import NetworkManagerFramework

final class AIViewModel: ObservableObject {
  private let api = "https://api.together.xyz/v1/chat/completions"
    private var key = "affa35a77f92307cf711d58b82dad4152dbeadd3ff5bd262021eab70293e5d0d"
  private var webService: PostServiceProtocol
  @Published var prompt: String = ""
  @Published var responseAI = ""
  @Published var isLoading = false
  
  init(webService: PostServiceProtocol = PostService()) {
    self.webService = webService
  }
  
  func fetchData() {
      let message = MessageModel(
        role: "user",
        content: """
          Respond only to questions or requests related to food, beverages, snacks, and meals. Ignore any other topics. User’s input follows: [\(prompt)]
          """
      )
      
      let body = BodyModel(
        model: "meta-llama/Meta-Llama-3.1-405B-Instruct-Turbo",
        messages: [message]
      )
    
    isLoading = true
      
      Task {

        
        do {
          let response: ChatCompletionResponse = try await webService.postData(
            urlString: api,
            headers: [
              "Authorization": "Bearer \(key)",
              "Content-Type": "application/json"
            ],
            body: body
          )
          
          guard let res = response.choices.first?.message.content else {return}
          
          await MainActor.run {
            responseAI = res
            isLoading = false
            prompt = ""
          }
          
          print(res)
        } catch {
          print("Error fetching data: \(error)")
          await MainActor.run {
            isLoading = false
          }
        }
      }
    }
}
