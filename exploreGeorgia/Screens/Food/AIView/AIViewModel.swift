//
//  AIViewModel.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import Combine
import NetworkManagerFramework

@MainActor
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
    responseAI = ""
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
        
        responseAI = res
        isLoading = false
        prompt = ""
        
      } catch {
        isLoading = false
      }
    }
  }
}
