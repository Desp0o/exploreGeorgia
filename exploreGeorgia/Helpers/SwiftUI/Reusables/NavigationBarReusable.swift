//
//  NavigationBarReusable.swift
//  exploreGeorgia
//
//  Created by Despo on 13.01.25.
//

import SwiftUI

struct NavigationBarReusable: View {
  @Environment(\.dismiss) var dismiss
  let title: String
  
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
  }
}

#Preview {
  NavigationBarReusable(title: "liberty Square")
}
