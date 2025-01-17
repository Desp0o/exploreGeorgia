//
//  CustomAlert.swift
//  exploreGeorgia
//
//  Created by Despo on 10.01.25.
//

import SwiftUI

struct CustomAlert: View {
  @ObservedObject var alertManager: CustomAlertManager
  @State private var scaleEffect: CGFloat = 0.9
  let alertMessage: String
  let errorType: MessageType
  
  var body: some View {
    ZStack {
      Color.black.opacity(0.3).ignoresSafeArea()
      
      VStack(spacing: 20) {
        
        Image(systemName: "exclamationmark.triangle.fill")
          .defaultOptions()
          .foregroundStyle(errorType == .error ? .red : .yellow)
          .frame(width: 40, height: 40)
        
        Text(alertMessage)
          .styledText(
            .customBlack,
            16,
            .bold,
            .center
          )
        
        Button {
          alertManager.hideAlert()
        } label: {
          Text("OK")
            .styledText(
              .buttonPrimary,
              16,
              .bold
            )
        }
        .customStyledButton(height: 40)
      }
      .padding(.vertical, 20)
      .padding(.horizontal, 20)
      .background(.customWhite)
      .roundedCorners(12)
      .padding(.horizontal, 50)
      .scaleEffect(scaleEffect)
      .onAppear {
        withAnimation(.interpolatingSpring(stiffness: 170, damping: 15)) {
          scaleEffect = 1.0
        }
      }
    }
  }
}

#Preview {
  let message = "hey i am message here, hey i am message here"
  CustomAlert(alertManager: CustomAlertManager(), alertMessage: message, errorType: .warning)
}
