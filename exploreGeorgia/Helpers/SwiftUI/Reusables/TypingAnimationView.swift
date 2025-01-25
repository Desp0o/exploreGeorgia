//
//  TypingAnimationView.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import SwiftUI

struct TypingAnimationView: View {
  @State private var displayedText = ""
  @Binding var currentIndex: Int
  let fullText: String
  let typingSpeed: Double
  
  var body: some View {
    VStack{
      Text(displayedText)
        .multilineTextAlignment(.leading)
        .onAppear {
          startTypingAnimation()
        }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private func startTypingAnimation() {
    displayedText = ""
    currentIndex = 0
    
    Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
      if currentIndex < fullText.count {
        let index = fullText.index(fullText.startIndex, offsetBy: currentIndex)
        displayedText.append(fullText[index])
        currentIndex += 1
      } else {
        timer.invalidate()
      }
    }
  }
}
