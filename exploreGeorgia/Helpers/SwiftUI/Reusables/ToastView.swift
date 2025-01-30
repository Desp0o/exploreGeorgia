//
//  ToastView.swift
//  exploreGeorgia
//
//  Created by Despo on 09.01.25.
//

import SwiftUI

struct ToastView: View {
  let message: String
  let bgColor: ToastTypes
  
  var body: some View {
    Text(message)
      .styledText(.white, 16, .bold, .center)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 10)
      .frame(minHeight: 50)
      .background(bgColor.backgroundColor)
      .roundedCorners(12)
      .transition(.move(edge: .top).combined(with: .opacity))
      .zIndex(99)
      .padding(.top, 10)
  }
}
