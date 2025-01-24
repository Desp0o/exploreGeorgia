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
  
  var body: some View {
    VStack {
      ScrollView {
        VStack(spacing: 20) {
          Text("Do you love cooking at home? Then ask for a recipe!")
            .styledText(.customBlue, 16, .semibold, .center)
          
//          if !vm.responseAI.isEmpty {
            Text(vm.responseAI)
            .opacity(opacityPoint)
              .animation(.easeOut, value: vm.responseAI)
//          }
        }
      }
      .scrollBounceBehavior(.basedOnSize)
      .scrollIndicators(.hidden)
      .padding(.bottom, 20)
      
      VStack(spacing: 10) {
        TextEditorComponent(textForEditor: $vm.prompt, placeholder: "Example: Give me a recipe for Georgian food Khinkali.")
          .frame(height: 150)
        
        Button {
          vm.fetchData()
        } label: {
          Text("Send")
            .styledText(.customBlue, 16, .bold)
            .frame(maxWidth: .infinity)
            .frame(height: 30)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(.customBlue, lineWidth: 1)
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
        Color.black.opacity(0.3).ignoresSafeArea()
        VStack {
            ProgressView()
              .scaleEffect(1.5)
              .tint(.customVine)
            
            Text("We are processing the best answer for you. Please stand by.")
            .styledText(.customVine, 13, .semibold, .center)
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
