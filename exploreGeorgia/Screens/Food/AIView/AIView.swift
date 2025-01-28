//
//  AIView.swift
//  exploreGeorgia
//
//  Created by Despo on 25.01.25.
//

import SwiftUI

struct AIView: View {
  @StateObject var vm = AIViewModel()
  @State private var opacityPoint: CGFloat = 0
  @State var currentIndex = 0
  
  var body: some View {
    VStack {
      ScrollViewReader { proxy in
        ScrollView {
          VStack(spacing: 20) {
            Text("Do you love cooking at home? Then ask for a recipe!")
              .styledText(.customGreen, 16, .semibold, .center)
              .frame(maxWidth: .infinity)
            
            if vm.responseAI != "" {
              TypingAnimationView(currentIndex: $currentIndex, fullText: vm.responseAI, typingSpeed: 0.02)
                .onChange(of: currentIndex) { _ in
                  withAnimation {
                    proxy.scrollTo("bottom", anchor: .bottom)
                  }
                }
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .id("bottom")
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        .padding(.bottom, 20)
      }
      
      VStack(spacing: 10) {
        TextEditorComponent(textForEditor: $vm.prompt, placeholder: "Example: Give me a recipe for Georgian food Khinkali.")
          .frame(height: 150)
        
        Button {
          vm.fetchData()
        } label: {
          Text("Send")
            .styledText(.customGreen, 16, .bold)
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(.customGreen, lineWidth: 1)
            )
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(20)
    .background(.primaryWhite)
    .overlay {
      if vm.isLoading {
        ZStack {
          VStack {
            ProgressView()
              .scaleEffect(1.5)
              .tint(.customGreen)
            
            Text("We are processing the best answer for you. Please stand by.")
              .styledText(.customGreen, 13, .semibold, .center)
              .frame(maxWidth: 300)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .onChange(of: vm.responseAI) { _ in
      opacityPoint = 1
    }
  }
}

#Preview {
  AIView()
}
