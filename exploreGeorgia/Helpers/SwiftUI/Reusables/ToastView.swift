//
//  ToastView.swift
//  exploreGeorgia
//
//  Created by Despo on 09.01.25.
//

import SwiftUI

struct ToastView: View {
  let message: String
  let bgColor: Color
  
    var body: some View {
      Text(message)
        .styledText(
          .white,
          16,
          .bold
        )
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(bgColor)
        .roundedCorners(12)
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(99)
        .padding(.top, 10)
    }
}

#Preview {
  let msg = "test"
  let col = Color.green
  ToastView(message: msg, bgColor: col)
}
