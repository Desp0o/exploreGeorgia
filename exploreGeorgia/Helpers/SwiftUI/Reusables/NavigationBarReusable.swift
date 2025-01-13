//
//  NavigationBarReusable.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import SwiftUI

struct NavigationBarReusable: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    HStack {
      Button {
        dismiss()
      } label: {
        Image("backArrow")
          .padding(16)
          .background(.customWhite.opacity(0.5))
          .clipShape(Circle())
      }
      
      Spacer()
      
      Button {
        print("test")
      } label: {
        Image("bookmark")
          .renderingMode(.template)
          .resizable()
          .foregroundStyle(.white)
          .frame(width: 24, height: 24)
          .padding(6)
          .background(.customWhite.opacity(0.5))
          .clipShape(Circle())
      }
    }
    .padding(.top, (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.top ?? 0)
    .frame(width: UIScreen.main.bounds.width - 20)
    .zIndex(2)
  }
}

#Preview {
  NavigationBarReusable()
}
